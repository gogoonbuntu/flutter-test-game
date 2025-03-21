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

  static Job fromJson(Map<String, dynamic> json) {
    return Job(
      name: json['name'],
      hpBonus: json['hpBonus'],
      mpBonus: json['mpBonus'],
      atkBonus: json['atkBonus'],
      defBonus: json['defBonus'],
      spdBonus: json['spdBonus'],
      description: json['description'],
      skills: (json['skills'] as List).map((s) => Skill.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }

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
          name: 'Basic Attack',
          damage: 15,
          mpCost: 0,
          probability: 0.9,
          description: 'A basic sword attack',
          hitCount: 1,
        ),
        Skill(
          name: 'Taunt',
          damage: 0,
          mpCost: 0,
          probability: 1.0,
          description: 'Provoke the enemy to attack you',
          hitCount: 1,
          effect: {'defense_boost': 2},
        ),
        Skill(
          name: 'Power Strike',
          damage: 30,
          mpCost: 10,
          probability: 0.7,
          description: 'A powerful strike',
          hitCount: 1,
        ),
        Skill(
          name: 'Defensive Stance',
          damage: 0,
          mpCost: 15,
          probability: 0.8,
          description: 'Increases defense temporarily',
          hitCount: 1,
          effect: {'defense_boost': 5},
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
          name: 'Magic Dart',
          damage: 10,
          mpCost: 0,
          probability: 0.95,
          description: 'A small magical projectile',
          hitCount: 1,
        ),
        Skill(
          name: 'Focus',
          damage: 0,
          mpCost: 0,
          probability: 1.0,
          description: 'Focus your mind to prepare for spellcasting',
          hitCount: 1,
          effect: {'mp_regen': 5},
        ),
        Skill(
          name: 'Fireball',
          damage: 40,
          mpCost: 20,
          probability: 0.6,
          description: 'Launches a ball of fire',
          hitCount: 1,
        ),
        Skill(
          name: 'Ice Shield',
          damage: 0,
          mpCost: 15,
          probability: 0.7,
          description: 'Creates a protective ice barrier',
          hitCount: 1,
          effect: {'defense_boost': 4},
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
          name: 'Quick Slash',
          damage: 12,
          mpCost: 0,
          probability: 0.95,
          description: 'A swift dagger attack',
          hitCount: 1,
        ),
        Skill(
          name: 'Analyze',
          damage: 0,
          mpCost: 0,
          probability: 1.0,
          description: 'Study the enemy for weak points',
          hitCount: 1,
          effect: {'critical_chance': 0.1},
        ),
        Skill(
          name: 'Quick Strike',
          damage: 20,
          mpCost: 5,
          probability: 0.8,
          description: 'A fast attack with high accuracy',
          hitCount: 1,
        ),
        Skill(
          name: 'Shadow Step',
          damage: 0,
          mpCost: 10,
          probability: 0.7,
          description: 'Increases evasion temporarily',
          hitCount: 1,
          effect: {'evasion_boost': 0.2},
        ),
      ],
    ),
  ];
}
