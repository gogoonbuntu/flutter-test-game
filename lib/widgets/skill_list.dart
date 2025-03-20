import 'package:flutter/material.dart';
import '../models/skill.dart';

class SkillList extends StatelessWidget {
  const SkillList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2, // Example skills
      itemBuilder: (context, index) {
        final skills = [
          const Skill(
            name: 'Power Strike',
            damage: 30,
            mpCost: 10,
            probability: 0.7,
            description: 'A powerful strike',
          ),
          const Skill(
            name: 'Defensive Stance',
            damage: 0,
            mpCost: 15,
            probability: 0.8,
            description: 'Increases defense temporarily',
          ),
        ];

        final skill = skills[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: Text(skill.name),
            subtitle: Text(skill.description),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('MP: ${skill.mpCost}'),
                Text('${(skill.probability * 100).toInt()}%'),
              ],
            ),
          ),
        );
      },
    );
  }
}
