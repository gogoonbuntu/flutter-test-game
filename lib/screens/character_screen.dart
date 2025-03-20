import 'package:flutter/material.dart';
import '../models/character.dart';
import '../widgets/stat_card.dart';
import '../widgets/skill_list.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Level 1 Human Warrior',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.grey[200],
                    ),
                    const Text('EXP: 50/100'),
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
              children: const [
                StatCard(
                  label: 'HP',
                  value: 100,
                  color: Colors.red,
                  icon: Icons.favorite,
                ),
                StatCard(
                  label: 'MP',
                  value: 50,
                  color: Colors.blue,
                  icon: Icons.local_fire_department,
                ),
                StatCard(
                  label: 'ATK',
                  value: 15,
                  color: Colors.orange,
                  icon: Icons.sports_kabaddi,
                ),
                StatCard(
                  label: 'DEF',
                  value: 12,
                  color: Colors.green,
                  icon: Icons.shield,
                ),
                StatCard(
                  label: 'SPD',
                  value: 10,
                  color: Colors.purple,
                  icon: Icons.speed,
                ),
                StatCard(
                  label: 'Skill %',
                  value: 50,
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
            const SkillList(),
          ],
        ),
      ),
    );
  }
}
