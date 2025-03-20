import 'skill.dart';

class Job {
  final String name;
  final int hpBonus;
  final int mpBonus;
  final int atkBonus;
  final int defBonus;
  final int spdBonus;
  final String description;
  final List<Skill> skills;

  const Job({
    required this.name,
    required this.hpBonus,
    required this.mpBonus,
    required this.atkBonus,
    required this.defBonus,
    required this.spdBonus,
    required this.description,
    required this.skills,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'hpBonus': hpBonus,
    'mpBonus': mpBonus,
    'atkBonus': atkBonus,
    'defBonus': defBonus,
    'spdBonus': spdBonus,
    'description': description,
    'skills': skills.map((s) => s.toJson()).toList(),
  };

  static final List<Job> jobs = [
    Job(
      name: 'Warrior',
      hpBonus: 30,
      mpBonus: 0,
      atkBonus: 5,
      defBonus: 3,
      spdBonus: 0,
      description: 'Strong physical attacker',
      skills: [
        Skill(
          name: 'Power Strike',
          damage: 30,
          mpCost: 10,
          probability: 0.7,
          description: 'A powerful strike',
        ),
        Skill(
          name: 'Defensive Stance',
          damage: 0,
          mpCost: 15,
          probability: 0.8,
          description: 'Increases defense temporarily',
        ),
      ],
    ),
    Job(
      name: 'Mage',
      hpBonus: 0,
      mpBonus: 50,
      atkBonus: 1,
      defBonus: 0,
      spdBonus: 1,
      description: 'Powerful magic user',
      skills: [
        Skill(
          name: 'Fireball',
          damage: 40,
          mpCost: 20,
          probability: 0.6,
          description: 'Launches a ball of fire',
        ),
        Skill(
          name: 'Ice Shield',
          damage: 0,
          mpCost: 15,
          probability: 0.7,
          description: 'Creates a protective ice barrier',
        ),
      ],
    ),
    Job(
      name: 'Rogue',
      hpBonus: 10,
      mpBonus: 10,
      atkBonus: 3,
      defBonus: 0,
      spdBonus: 5,
      description: 'Fast and agile fighter',
      skills: [
        Skill(
          name: 'Quick Strike',
          damage: 20,
          mpCost: 5,
          probability: 0.8,
          description: 'A fast attack with high accuracy',
        ),
        Skill(
          name: 'Shadow Step',
          damage: 0,
          mpCost: 10,
          probability: 0.7,
          description: 'Increases evasion temporarily',
        ),
      ],
    ),
  ];
}
