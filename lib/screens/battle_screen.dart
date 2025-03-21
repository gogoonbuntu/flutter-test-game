import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../models/item.dart';
import '../models/game_state.dart';
import '../models/benefit.dart';
import '../models/character.dart';
import '../services/notification_service.dart';
import '../services/benefit_service.dart';
import 'dart:math';
import 'dart:async';
import '../services/character_visual_service.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  BattleScreenState createState() => BattleScreenState();
}

class BattleScreenState extends State<BattleScreen> {
  late final GameState gameState;
  final NotificationService _notificationService = NotificationService();
  late int enemyHp;
  late int enemyMaxHp;
  late String enemyName;
  late int enemyLevel;
  List<String> battleLog = [];
  bool isBattleOver = false;
  bool _isLoading = true;
  bool _isAutoAttackEnabled = false;
  Timer? _autoAttackTimer;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    gameState = GameState();
    _loadGameState();
    _startCooldownTimer();
  }

  @override
  void dispose() {
    _autoAttackTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadGameState() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await gameState.loadGame();
      
      if (gameState.character != null) {
        _notificationService.addNotification('캐릭터 로드 성공: ${gameState.character!.name}');
        _initializeEnemy();
        _notificationService.addNotification('전투가 시작되었습니다!');
      } else {
        _notificationService.addNotification('캐릭터를 찾을 수 없습니다. 캐릭터를 먼저 생성해주세요.');
      }
    } catch (e) {
      _notificationService.addNotification('게임 데이터를 불러오는데 실패했습니다: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  void _startAutoAttack() {
    _autoAttackTimer?.cancel();
    _autoAttackTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!isBattleOver && _isAutoAttackEnabled && mounted) {
        final character = gameState.character;
        if (character == null) return;

        // MP가 소모되지 않는 스킬 중 쿨타임이 없는 스킬 찾기
        final basicSkill = character.skills.firstWhere(
          (skill) => skill.mpCost == 0 && !skill.isOnCooldown,
          orElse: () => Skill(
            name: '기본 공격',
            damage: 5,
            mpCost: 0,
            probability: 1.0,
            description: '기본 공격',
          ),
        );

        if (basicSkill != null) {
          _useSkill(basicSkill);
        }
      }
    });
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _toggleAutoAttack() {
    setState(() {
      _isAutoAttackEnabled = !_isAutoAttackEnabled;
      if (_isAutoAttackEnabled) {
        _startAutoAttack();
        _notificationService.addNotification('자동 공격 모드 활성화');
      } else {
        _autoAttackTimer?.cancel();
        _notificationService.addNotification('자동 공격 모드 비활성화');
      }
    });
  }

  void _useSkill(Skill skill) {
    if (isBattleOver) return;
    
    final character = gameState.character;
    if (character == null) return;

    if (skill.isOnCooldown) {
      _addToBattleLog('${skill.name}의 쿨타임이 ${skill.remainingCooldown}초 남았습니다.');
      return;
    }

    if (character.mp < skill.mpCost) {
      _addToBattleLog('MP가 부족합니다!');
      return;
    }

    setState(() {
      character.mp -= skill.mpCost;
      skill.use();
      
      // Check if skill hits based on probability and character's skill probability
      if (Random().nextDouble() <= skill.probability * character.skillProbability) {
        final damage = (skill.damage * (character.atk / 10)).round();
        enemyHp = max(0, enemyHp - damage);
        _addToBattleLog('${skill.name} 사용! $damage의 데미지를 입혔습니다!');
        
        if (enemyHp <= 0) {
          _handleVictory();
          return;
        }
      } else {
        _addToBattleLog('${skill.name}이(가) 빗나갔습니다!');
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
        _addToBattleLog('아이템 획득: ${item.name}!');
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
    // 3개의 랜덤 베네핏 생성 (같은 레벨의 베네핏만 선택)
    final benefits = BenefitService.getRandomBenefits(3, sameRarity: true);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('승리!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$enemyName을(를) 처치했습니다!'),
              Text('경험치 $expGain 획득!'),
              Text('골드 $goldGain 획득!'),
              const SizedBox(height: 16),
              const Text(
                '베네핏을 선택하세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...benefits.map((benefit) => Card(
                child: InkWell(
                  onTap: () {
                    benefit.apply(gameState.character!);
                    gameState.saveGame();
                    _addToBattleLog('획득한 베네핏: ${benefit.name}');
                    Navigator.pop(context); // Close dialog
                    _showContinueBattleDialog();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              benefit.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            ...List.generate(
                              benefit.rarity,
                              (index) => const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          benefit.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showContinueBattleDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('전투 계속'),
        content: const Text('3초 후 전투가 계속됩니다. 취소하시면 홈으로 돌아갑니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home
            },
            child: const Text('취소'),
          ),
        ],
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context); // Close dialog
        setState(() {
          isBattleOver = false;
          _initializeEnemy();
          _notificationService.addNotification('새로운 전투가 시작되었습니다!');
        });
      }
    });
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

  Widget _buildCharacterVisual(Character character) {
    final visualService = CharacterVisualService();
    final imagePath = visualService.getCharacterImage(character.race, character.job);
    
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    '${character.race.name} ${character.job.name}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('전투'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (gameState.character == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('전투'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('캐릭터를 먼저 생성해주세요'),
              SizedBox(height: 16),
              Icon(Icons.warning, size: 48, color: Colors.orange),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('전투'),
        actions: [
          IconButton(
            icon: Icon(_isAutoAttackEnabled ? Icons.play_circle : Icons.pause_circle),
            onPressed: _toggleAutoAttack,
            tooltip: _isAutoAttackEnabled ? '자동 공격 중지' : '자동 공격 시작',
          ),
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
              _addToBattleLog('${item.name} 사용!');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 전투 로그
          Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: ListView.builder(
              itemCount: battleLog.length,
              itemBuilder: (context, index) {
                return Text(
                  battleLog[battleLog.length - 1 - index],
                  style: const TextStyle(fontSize: 14),
                );
              },
            ),
          ),
          
          // 전투 영역
          Expanded(
            child: Row(
              children: [
                // 플레이어 캐릭터
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCharacterVisual(gameState.character!),
                      const SizedBox(height: 16),
                      _buildStatBars(gameState.character!),
                    ],
                  ),
                ),
                
                // VS 텍스트
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // 적 캐릭터
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEnemyVisual(),
                      const SizedBox(height: 16),
                      _buildEnemyStatBars(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 스킬 버튼
          Container(
            height: 120,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: gameState.character?.skills.map((skill) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: 100,
                  child: _buildSkillButton(skill),
                ),
              )).toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBars(Character character) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildStatBar('HP', character.hp, character.maxHp, Colors.red),
          const SizedBox(height: 4),
          _buildStatBar('MP', character.mp, character.maxMp, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, int current, int max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $current/$max',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 2),
        LinearProgressIndicator(
          value: current / max,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildEnemyVisual() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bug_report, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                enemyName,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnemyStatBars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildStatBar('HP', enemyHp, enemyMaxHp, Colors.red),
        ],
      ),
    );
  }

  Widget _buildSkillButton(Skill skill) {
    final character = gameState.character;
    if (character == null) return const SizedBox();

    final bool canUse = character.mp >= skill.mpCost && !isBattleOver && !skill.isOnCooldown;
    
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
              if (skill.isOnCooldown)
                Text(
                  '쿨타임: ${skill.remainingCooldown}초',
                  style: const TextStyle(color: Colors.orange),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
