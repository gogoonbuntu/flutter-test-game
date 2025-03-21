import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/character.dart';
import 'models/race.dart';
import 'models/job.dart';
import 'services/notification_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late Character character;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    final SharedPreferences prefs = await _prefs;
    final String? characterJson = prefs.getString('character');
    setState(() {
      character = characterJson != null
          ? Character.fromJson(json.decode(characterJson))
          : Character(
              name: 'New Character',
              race: Race.races.first,
              job: Job.jobs.first,
            );
    });

    _notificationService
        .addNotification('Character loaded: Level ${character.level}');
  }

  Future<void> _saveCharacter() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('character', json.encode(character.toJson()));
  }

  void _trainStat(String stat) {
    setState(() {
      character.trainStat(stat);
      _saveCharacter();
    });

    // Get the stat value based on the stat name
    dynamic statValue;
    switch (stat) {
      case 'HP':
        statValue = character.hp;
        break;
      case 'MP':
        statValue = character.mp;
        break;
      case 'ATK':
        statValue = character.atk;
        break;
      case 'DEF':
        statValue = character.def;
        break;
      case 'SPD':
        statValue = character.spd;
        break;
      case 'SKILL':
        statValue = '${(character.skillProbability * 100).toInt()}%';
        break;
      default:
        statValue = 'updated';
    }

    _notificationService
        .addNotification('Trained $stat! New value: $statValue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG Stat Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Level ${character.level}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    LinearProgressIndicator(
                      value: character.exp / 100,
                    ),
                    Text('EXP: ${character.exp}/100'),
                    Text('Gold: ${character.gold}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _buildStatCard('HP', character.hp, Colors.red,
                      maxValue: character.maxHp),
                  _buildStatCard('MP', character.mp, Colors.blue,
                      maxValue: character.maxMp),
                  _buildStatCard('ATK', character.atk, Colors.orange),
                  _buildStatCard('DEF', character.def, Colors.green),
                  _buildStatCard('SPD', character.spd, Colors.purple),
                  _buildStatCard('SKILL',
                      (character.skillProbability * 100).toInt(), Colors.cyan,
                      isPercentage: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String stat, int value, Color color,
      {int? maxValue, bool isPercentage = false}) {
    return Card(
      child: InkWell(
        onTap: () => _trainStat(stat),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stat,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (maxValue != null)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: value / maxValue,
                      backgroundColor: color.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$value / $maxValue',
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  isPercentage ? '$value%' : value.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                      ),
                ),
              const SizedBox(height: 8),
              const Text('Tap to train'),
            ],
          ),
        ),
      ),
    );
  }
}
