import 'skill.dart';

enum Job {
  warrior,
  mage,
  archer,
  rogue,
  priest,
  paladin
}

class JobData {
  final String name;
  final int hpBonus;
  final int mpBonus;
  final int atkBonus;
  final int defBonus;
  final int spdBonus;
  final String description;
  final List<Skill> skills;

  const JobData({
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

  static JobData fromJson(Map<String, dynamic> json) {
    return JobData(
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

  static final Map<Job, JobData> jobData = {
    Job.warrior: JobData(
      name: 'Warrior',
      hpBonus: 30,
      mpBonus: 0,
      atkBonus: 5,
      defBonus: 3,
      spdBonus: 0,
      description: 'Strong physical attacker',
      skills: [
        const Skill(
          name: 'Basic Attack',
          damage: 15,
          mpCost: 0,
          probability: 0.9,
          description: 'A basic sword attack',
          hitCount: 1,
        ),
        const Skill(
          name: 'Taunt',
          damage: 0,
          mpCost: 0,
          probability: 1.0,
          description: 'Provoke the enemy to attack you',
          hitCount: 1,
          effect: {'defense_boost': 2},
        ),
        const Skill(
          name: 'Power Strike',
          damage: 30,
          mpCost: 10,
          probability: 0.7,
          description: 'A powerful strike',
          hitCount: 1,
        ),
        const Skill(
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
    Job.mage: JobData(
      name: 'Mage',
      hpBonus: 0,
      mpBonus: 50,
      atkBonus: 1,
      defBonus: 0,
      spdBonus: 1,
      description: 'Powerful magic user',
      skills: [
        const Skill(
          name: 'Magic Dart',
          damage: 10,
          mpCost: 0,
          probability: 0.95,
          description: 'A small magical projectile',
          hitCount: 1,
        ),
        const Skill(
          name: 'Focus',
          damage: 0,
          mpCost: 0,
          probability: 1.0,
          description: 'Focus your mind to prepare for spellcasting',
          hitCount: 1,
          effect: {'mp_regen': 5},
        ),
        const Skill(
          name: 'Fireball',
          damage: 40,
          mpCost: 20,
          probability: 0.6,
          description: 'Launches a ball of fire',
          hitCount: 1,
        ),
        const Skill(
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
    Job.rogue: JobData(
      name: 'Rogue',
      hpBonus: 10,
      mpBonus: 10,
      atkBonus: 3,
      defBonus: 0,
      spdBonus: 5,
      description: 'Fast and agile fighter',
      skills: [
        const Skill(
          name: 'Quick Slash',
          damage: 12,
          mpCost: 0,
          probability: 0.95,
          description: 'A swift dagger attack',
          hitCount: 1,
        ),
        const Skill(
          name: 'Analyze',
          damage: 0,
          mpCost: 0,
          probability: 1.0,
          description: 'Study the enemy for weak points',
          hitCount: 1,
          effect: {'critical_chance': 0.1},
        ),
        const Skill(
          name: 'Quick Strike',
          damage: 20,
          mpCost: 5,
          probability: 0.8,
          description: 'A fast attack with high accuracy',
          hitCount: 1,
        ),
        const Skill(
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
    Job.archer: JobData(
      name: 'Archer',
      hpBonus: 15,
      mpBonus: 15,
      atkBonus: 4,
      defBonus: 1,
      spdBonus: 3,
      description: 'Long-range specialist',
      skills: [
        const Skill(
          name: 'Quick Shot',
          damage: 8,
          mpCost: 0,
          probability: 0.95,
          description: 'A quick arrow shot',
          hitCount: 1,
        ),
        const Skill(
          name: 'Precision Shot',
          damage: 25,
          mpCost: 10,
          probability: 0.7,
          description: 'A precise arrow shot',
          hitCount: 1,
        ),
        const Skill(
          name: 'Arrow Rain',
          damage: 15,
          mpCost: 15,
          probability: 0.6,
          description: 'Shoot multiple arrows',
          hitCount: 3,
        ),
        const Skill(
          name: 'Eagle Eye',
          damage: 0,
          mpCost: 10,
          probability: 0.8,
          description: 'Increases accuracy temporarily',
          hitCount: 1,
          effect: {'accuracy_boost': 0.2},
        ),
      ],
    ),
    Job.priest: JobData(
      name: 'Priest',
      hpBonus: 20,
      mpBonus: 40,
      atkBonus: 1,
      defBonus: 2,
      spdBonus: 1,
      description: 'Healing and support specialist',
      skills: [
        const Skill(
          name: 'Holy Light',
          damage: 10,
          mpCost: 0,
          probability: 0.9,
          description: 'A holy light attack',
          hitCount: 1,
        ),
        const Skill(
          name: 'Heal',
          damage: -30,
          mpCost: 15,
          probability: 0.8,
          description: 'Heal yourself',
          hitCount: 1,
        ),
        const Skill(
          name: 'Blessing',
          damage: 0,
          mpCost: 20,
          probability: 0.7,
          description: 'Temporary stat boost',
          hitCount: 1,
          effect: {'atk_boost': 3, 'def_boost': 3},
        ),
        const Skill(
          name: 'Holy Shield',
          damage: 0,
          mpCost: 25,
          probability: 0.6,
          description: 'Create a protective holy barrier',
          hitCount: 1,
          effect: {'defense_boost': 6},
        ),
      ],
    ),
    Job.paladin: JobData(
      name: 'Paladin',
      hpBonus: 40,
      mpBonus: 20,
      atkBonus: 3,
      defBonus: 4,
      spdBonus: 0,
      description: 'Holy warrior with high defense',
      skills: [
        const Skill(
          name: 'Holy Strike',
          damage: 20,
          mpCost: 0,
          probability: 0.9,
          description: 'A holy-powered attack',
          hitCount: 1,
        ),
        const Skill(
          name: 'Divine Shield',
          damage: 0,
          mpCost: 15,
          probability: 0.8,
          description: 'Create a divine shield',
          hitCount: 1,
          effect: {'defense_boost': 5},
        ),
        const Skill(
          name: 'Holy Smite',
          damage: 35,
          mpCost: 20,
          probability: 0.6,
          description: 'A powerful holy attack',
          hitCount: 1,
        ),
        const Skill(
          name: 'Lay on Hands',
          damage: -40,
          mpCost: 25,
          probability: 0.7,
          description: 'Heal yourself with holy power',
          hitCount: 1,
        ),
      ],
    ),
  };
}
