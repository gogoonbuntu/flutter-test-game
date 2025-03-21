import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../models/item.dart';
import '../models/game_state.dart';
import '../services/notification_service.dart';
import 'dart:math';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  BattleScreenState createState() => BattleScreenState();
}

class BattleScreenState extends State<BattleScreen> {
  final GameState gameState = GameState();
  final NotificationService _notificationService = NotificationService();
  late int enemyHp;
  late int enemyMaxHp;
  late String enemyName;
  late int enemyLevel;
  List<String> battleLog = [];
  bool isBattleOver = false;

  @override
  void initState() {
    super.initState();
    _initializeEnemy();
    _notificationService.addNotification('Battle started with $enemyName!');
  }

  void _initializeEnemy() {
    final random = Random();
    enemyLevel = max(1, (gameState.character?.level ?? 1) - 1 + random.nextInt(3));
    enemyMaxHp = 50 + enemyLevel * 10;
    enemyHp = enemyMaxHp;
    enemyName = _generateEnemyName();
  }

  String _generateEnemyName() {
    final enemies = [
      'Goblin',
      'Orc',
      'Skeleton',
      'Wolf',
      'Slime',
      'Bat',
    ];
    return '${enemies[Random().nextInt(enemies.length)]} Lv.${enemyLevel}';
  }

  void _useSkill(Skill skill) {
    if (isBattleOver) return;
    
    final character = gameState.character;
    if (character == null) return;

    if (character.mp < skill.mpCost) {
      _addToBattleLog('Not enough MP!');
      return;
    }

    setState(() {
      character.mp -= skill.mpCost;
      
      // Check if skill hits based on probability and character's skill probability
      if (Random().nextDouble() <= skill.probability * character.skillProbability) {
        final damage = (skill.damage * (character.atk / 10)).round();
        enemyHp = max(0, enemyHp - damage);
        _addToBattleLog('Used ${skill.name}! Dealt $damage damage!');
        
        if (enemyHp <= 0) {
          _handleVictory();
          return;
        }
      } else {
        _addToBattleLog('${skill.name} missed!');
      }

      // Enemy turn
      _enemyAttack();
    });
  }

  void _enemyAttack() {
    if (isBattleOver) return;
    
    final character = gameState.character;
    if (character == null) return;

    setState(() {
      final baseDamage = 5 + enemyLevel * 2;
      final damage = max(1, (baseDamage * (10 / (10 + character.def))).round());
      character.hp = max(0, character.hp - damage);
      _addToBattleLog('$enemyName attacks! Dealt $damage damage!');

      if (character.hp <= 0) {
        _handleDefeat();
      }
    });
  }

  void _handleVictory() {
    final character = gameState.character;
    if (character == null) return;

    setState(() {
      isBattleOver = true;
      
      // Calculate rewards
      final expGain = 20 + enemyLevel * 10;
      final goldGain = 10 + enemyLevel * 5;
      
      character.gainExp(expGain);
      character.gold += goldGain;
      
      // Random item drop
      if (Random().nextDouble() < 0.7) { // 70% drop rate
        final item = _generateRandomItem();
        gameState.addItem(item);
        _addToBattleLog('Got item: ${item.name}!');
      }

      _showVictoryDialog(expGain, goldGain);
    });
    
    gameState.saveGame();
  }

  Item _generateRandomItem() {
    final random = Random();
    final itemTypes = [ItemType.weapon, ItemType.armor, ItemType.potion];
    final type = itemTypes[random.nextInt(itemTypes.length)];
    
    switch (type) {
      case ItemType.weapon:
        return Item(
          name: 'Sharp Sword',
          type: type,
          value: 50 + enemyLevel * 10,
          description: 'A sharp sword found from enemy',
          stats: {'ATK': 2 + enemyLevel},
        );
      case ItemType.armor:
        return Item(
          name: 'Sturdy Armor',
          type: type,
          value: 50 + enemyLevel * 10,
          description: 'A sturdy armor found from enemy',
          stats: {'DEF': 2 + enemyLevel},
        );
      case ItemType.potion:
        return Item(
          name: 'Health Potion',
          type: type,
          value: 30,
          description: 'Restores 50 HP',
          stats: {'HP': 50},
        );
    }
  }

  void _handleDefeat() {
    final character = gameState.character;
    if (character == null) return;

    setState(() {
      isBattleOver = true;
      // Lose some gold on defeat
      character.gold = max(0, character.gold - 50);
      gameState.saveGame();
    });

    _showDefeatDialog();
  }

  void _addToBattleLog(String message) {
    setState(() {
      battleLog.insert(0, message);
      if (battleLog.length > 5) {
        battleLog.removeLast();
      }
    });
    
    // Also add to the global notification service
    _notificationService.addNotification(message);
  }

  void _showVictoryDialog(int expGain, int goldGain) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Victory!'),
        content: SizedBox(
          width: double.minPositive,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You defeated $enemyName!'),
              Text('Gained $expGain EXP!'),
              Text('Gained $goldGain Gold!'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showDefeatDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Defeat'),
        content: SizedBox(
          width: double.minPositive,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('You were defeated...'),
              const Text('Lost 50 Gold'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('Return'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = gameState.character;
    if (character == null) {
      return const Scaffold(
        body: Center(
          child: Text('No character found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle'),
        actions: [
          PopupMenuButton<Item>(
            icon: const Icon(Icons.healing),
            itemBuilder: (context) => gameState.inventory
                .where((item) => item.type == ItemType.potion)
                .map((item) => PopupMenuItem(
                      value: item,
                      child: Text(item.name),
                    ))
                .toList(),
            onSelected: (item) {
              gameState.useItem(item);
              _addToBattleLog('Used ${item.name}!');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Enemy section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.catching_pokemon, size: 48),
                      Text(
                        enemyName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: enemyHp / enemyMaxHp,
                        color: Colors.red,
                        backgroundColor: Colors.red.withOpacity(0.2),
                        minHeight: 10,
                      ),
                      Text('HP: $enemyHp / $enemyMaxHp'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Player status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('HP'),
                                LinearProgressIndicator(
                                  value: character.hp / character.maxHp,
                                  color: Colors.red,
                                  backgroundColor: Colors.red.withOpacity(0.2),
                                  minHeight: 10,
                                ),
                                Text('${character.hp} / ${character.maxHp}'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('MP'),
                                LinearProgressIndicator(
                                  value: character.mp / character.maxMp,
                                  color: Colors.blue,
                                  backgroundColor: Colors.blue.withOpacity(0.2),
                                  minHeight: 10,
                                ),
                                Text('${character.mp} / ${character.maxMp}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Battle log
              Card(
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: battleLog.length,
                    itemBuilder: (context, index) => Text(
                      battleLog[index],
                      style: TextStyle(
                        color: index == 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Skills
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.5, 
                  children: character.skills.map((skill) => _buildSkillButton(skill)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillButton(Skill skill) {
    final character = gameState.character;
    if (character == null) return const SizedBox();

    final bool canUse = character.mp >= skill.mpCost && !isBattleOver;
    
    return Card(
      child: InkWell(
        onTap: canUse ? () => _useSkill(skill) : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skill.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: canUse ? Colors.black : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'DMG: ${skill.damage}',
                style: TextStyle(color: canUse ? Colors.red : Colors.grey),
              ),
              Text(
                'MP: ${skill.mpCost}',
                style: TextStyle(color: canUse ? Colors.blue : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
