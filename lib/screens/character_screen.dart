import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/character_manager.dart';
import '../widgets/stat_card.dart';
import '../widgets/skill_list.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final CharacterManager _characterManager = CharacterManager();
  Character? _character;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    setState(() {
      _isLoading = true;
    });

    await _characterManager.loadCharacters();
    
    setState(() {
      _character = _characterManager.activeCharacter;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _character == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Character Stats'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final expToNextLevel = _character!.level * 100;
    final currentExp = _character!.exp;
    final expProgress = currentExp / expToNextLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Character avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        _character!.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _character!.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Level ${_character!.level} ${_character!.race.name} ${_character!.job.name}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: expProgress,
                      backgroundColor: Colors.grey[200],
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 4),
                    Text('EXP: $currentExp/$expToNextLevel'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Stats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.5,
              children: [
                StatCard(
                  label: 'HP',
                  value: _character!.hp,
                  maxValue: _character!.maxHp,
                  color: Colors.red,
                  icon: Icons.favorite,
                ),
                StatCard(
                  label: 'MP',
                  value: _character!.mp,
                  maxValue: _character!.maxMp,
                  color: Colors.blue,
                  icon: Icons.local_fire_department,
                ),
                StatCard(
                  label: 'ATK',
                  value: _character!.atk,
                  color: Colors.orange,
                  icon: Icons.sports_kabaddi,
                ),
                StatCard(
                  label: 'DEF',
                  value: _character!.def,
                  color: Colors.green,
                  icon: Icons.shield,
                ),
                StatCard(
                  label: 'SPD',
                  value: _character!.spd,
                  color: Colors.purple,
                  icon: Icons.speed,
                ),
                StatCard(
                  label: 'Skill %',
                  value: (_character!.skillProbability * 100).round(),
                  color: Colors.cyan,
                  icon: Icons.auto_awesome,
                  isPercentage: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Skills',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SkillList(skills: _character!.skills),
          ],
        ),
      ),
    );
  }
}
