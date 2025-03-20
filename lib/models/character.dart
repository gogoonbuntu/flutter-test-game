import 'race.dart';
import 'job.dart';
import 'skill.dart';
import 'item.dart';

class Character {
  final String name;
  Race race;
  Job job;
  int level;
  int hp;
  int mp;
  int atk;
  int def;
  int spd;
  int exp;
  int gold;
  double skillProbability;
  List<Skill> skills;
  List<Item> inventory;

  // Add max stats
  int get maxHp => 100 + (level - 1) * 10 + race.hpBonus + job.hpBonus;
  int get maxMp => 50 + (level - 1) * 5 + race.mpBonus + job.mpBonus;
  int get baseAtk => 10 + (level - 1) * 2 + race.atkBonus + job.atkBonus;
  int get baseDef => 10 + (level - 1) * 2 + race.defBonus + job.defBonus;
  int get baseSpd => 10 + (level - 1) * 1 + race.spdBonus + job.spdBonus;

  Character({
    required this.name,
    required this.race,
    required this.job,
    this.level = 1,
    int? hp,
    int? mp,
    this.atk = 10,
    this.def = 10,
    this.spd = 10,
    this.exp = 0,
    this.gold = 0,
    this.skillProbability = 0.5,
    List<Skill>? skills,
    List<Item>? inventory,
  }) : skills = skills ?? [],
       inventory = inventory ?? [],
       hp = hp ?? (100 + race.hpBonus + job.hpBonus),
       mp = mp ?? (50 + race.mpBonus + job.mpBonus) {
    // Initialize with job skills
    this.skills.addAll(job.skills);
  }

  void trainStat(String stat) {
    switch (stat) {
      case 'HP':
        hp = (hp + 10).clamp(0, maxHp);
        break;
      case 'MP':
        mp = (mp + 5).clamp(0, maxMp);
        break;
      case 'ATK':
        atk += 2;
        break;
      case 'DEF':
        def += 2;
        break;
      case 'SPD':
        spd += 2;
        break;
      case 'SKILL':
        skillProbability = (skillProbability + 0.02).clamp(0, 1.0);
        break;
    }
    gainExp(10);
  }

  void gainExp(int amount) {
    exp += amount;
    while (exp >= 100) {
      levelUp();
    }
  }

  void levelUp() {
    level++;
    exp = exp - 100;
    gold += 100;
    
    // Heal on level up
    hp = maxHp;
    mp = maxMp;
  }

  bool useSkill(Skill skill) {
    if (mp < skill.mpCost) return false;
    if (skillProbability < skill.probability) return false;
    
    mp -= skill.mpCost;
    return true;
  }

  void heal(int amount) {
    hp = (hp + amount).clamp(0, maxHp);
  }

  void restoreMp(int amount) {
    mp = (mp + amount).clamp(0, maxMp);
  }

  void addItem(Item item) {
    inventory.add(item);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'race': race.toJson(),
      'job': job.toJson(),
      'level': level,
      'hp': hp,
      'mp': mp,
      'atk': atk,
      'def': def,
      'spd': spd,
      'exp': exp,
      'gold': gold,
      'skillProbability': skillProbability,
      'skills': skills.map((s) => s.toJson()).toList(),
      'inventory': inventory.map((i) => i.toJson()).toList(),
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      race: Race.fromJson(json['race']),
      job: Job.fromJson(json['job']),
      level: json['level'],
      hp: json['hp'],
      mp: json['mp'],
      atk: json['atk'],
      def: json['def'],
      spd: json['spd'],
      exp: json['exp'],
      gold: json['gold'],
      skillProbability: json['skillProbability'],
      skills: (json['skills'] as List).map((s) => Skill.fromJson(s)).toList(),
      inventory: (json['inventory'] as List).map((i) => Item.fromJson(i)).toList(),
    );
  }
}
