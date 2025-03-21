import 'package:flutter/material.dart';
import '../models/skill.dart';

class SkillList extends StatelessWidget {
  final List<Skill> skills;

  const SkillList({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              skill.mpCost == 0 ? Icons.flash_on : Icons.auto_awesome,
              color: skill.mpCost == 0 ? Colors.amber : Colors.blue,
            ),
            title: Text(skill.name),
            subtitle: Text(skill.description),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('MP: ${skill.mpCost}'),
                Text('${(skill.probability * 100).toInt()}%'),
                if (skill.hitCount > 1)
                  Text('Hits: ${skill.hitCount}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}
