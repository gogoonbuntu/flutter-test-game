import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';
import 'character.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late Character character;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
          : Character();
    });
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
                  _buildStatCard('HP', character.hp, Colors.red),
                  _buildStatCard('MP', character.mp, Colors.blue),
                  _buildStatCard('ATK', character.atk, Colors.orange),
                  _buildStatCard('DEF', character.def, Colors.green),
                  _buildStatCard('SPD', character.spd, Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String stat, int value, Color color) {
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
              Text(
                value.toString(),
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
