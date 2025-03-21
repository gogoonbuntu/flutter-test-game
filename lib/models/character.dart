import 'dart:async';
import 'race.dart';
import 'job.dart';
import 'skill.dart';
import 'item.dart';

class Character {
  int id = 0; // Unique identifier for character management
  final String name;
  final String avatar; // Avatar image name
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
  DateTime _lastRegenTime = DateTime.now();
  Timer? _regenTimer;

  // Add max stats
  int get maxHp => 100 + (level - 1) * 10 + race.hpBonus + job.hpBonus;
  int get maxMp => 50 + (level - 1) * 5 + race.mpBonus + job.mpBonus;
  int get baseAtk => 10 + (level - 1) * 2 + race.atkBonus + job.atkBonus;
  int get baseDef => 10 + (level - 1) * 2 + race.defBonus + job.defBonus;
  int get baseSpd => 10 + (level - 1) * 1 + race.spdBonus + job.spdBonus;
  
  // Regeneration rates per minute
  int get hpRegenRate => 5 + (level ~/ 5);
  int get mpRegenRate => 3 + (level ~/ 5);

  Character({
    required this.name,
    required this.race,
    required this.job,
    this.avatar = 'default_avatar.png',
    this.id = 0,
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
    
    // Start regeneration timer
    startRegeneration();
  }

  void startRegeneration() {
    _regenTimer?.cancel();
    _regenTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      regenerateStats();
    });
  }

  void stopRegeneration() {
    _regenTimer?.cancel();
    _regenTimer = null;
  }

  void regenerateStats() {
    final now = DateTime.now();
    final minutesPassed = now.difference(_lastRegenTime).inMinutes;
    
    if (minutesPassed > 0) {
      // Regenerate HP and MP based on time passed
      heal(hpRegenRate * minutesPassed);
      restoreMp(mpRegenRate * minutesPassed);
      _lastRegenTime = now;
    }
  }

  // Add a new skill when leveling up
  void learnNewSkill() {
    // Basic skills that don't cost MP
    final basicSkills = [
      Skill(
        name: 'Quick Strike',
        damage: 5 + (level ~/ 2),
        mpCost: 0,
        probability: 0.9,
        description: 'A fast attack that costs no MP',
      ),
      Skill(
        name: 'Focus',
        damage: 0,
        mpCost: 0,
        probability: 1.0,
        description: 'Increase skill probability for the next turn',
        effect: {'skillProbability': 0.1},
      ),
    ];
    
    // Advanced skills that unlock at higher levels
    final advancedSkills = [
      Skill(
        name: 'Power Slash',
        damage: 15 + level,
        mpCost: 10,
        probability: 0.8,
        description: 'A powerful slash with high damage',
      ),
      Skill(
        name: 'Dual Strike',
        damage: 8 + (level ~/ 2),
        mpCost: 15,
        probability: 0.75,
        description: 'Strike twice with medium damage',
        hitCount: 2,
      ),
      Skill(
        name: 'Healing Aura',
        damage: 0,
        mpCost: 20,
        probability: 1.0,
        description: 'Restore HP over time',
        effect: {'heal': 10 + (level ~/ 2)},
      ),
      Skill(
        name: 'Mana Burst',
        damage: 20 + level * 2,
        mpCost: 30,
        probability: 0.7,
        description: 'A powerful magical attack',
      ),
    ];
    
    // Determine which skills the character can learn based on level
    List<Skill> learnableSkills = [];
    
    // Always can learn basic skills
    for (final skill in basicSkills) {
      if (!skills.any((s) => s.name == skill.name)) {
        learnableSkills.add(skill);
      }
    }
    
    // Can learn advanced skills based on level
    if (level >= 5) {
      final advancedSkill = advancedSkills[0]; // Power Slash at level 5
      if (!skills.any((s) => s.name == advancedSkill.name)) {
        learnableSkills.add(advancedSkill);
      }
    }
    
    if (level >= 10) {
      final advancedSkill = advancedSkills[1]; // Dual Strike at level 10
      if (!skills.any((s) => s.name == advancedSkill.name)) {
        learnableSkills.add(advancedSkill);
      }
    }
    
    if (level >= 15) {
      final advancedSkill = advancedSkills[2]; // Healing Aura at level 15
      if (!skills.any((s) => s.name == advancedSkill.name)) {
        learnableSkills.add(advancedSkill);
      }
    }
    
    if (level >= 20) {
      final advancedSkill = advancedSkills[3]; // Mana Burst at level 20
      if (!skills.any((s) => s.name == advancedSkill.name)) {
        learnableSkills.add(advancedSkill);
      }
    }
    
    // Learn a new skill if available
    if (learnableSkills.isNotEmpty) {
      final newSkill = learnableSkills.first;
      skills.add(newSkill);
      return;
    }
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
    
    // Check for new skills
    learnNewSkill();
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
      'id': id,
      'name': name,
      'avatar': avatar,
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
      'lastRegenTime': _lastRegenTime.millisecondsSinceEpoch,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    final character = Character(
      id: json['id'] ?? 0,
      name: json['name'],
      avatar: json['avatar'] ?? 'default_avatar.png',
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
    
    // Set the last regeneration time
    if (json.containsKey('lastRegenTime')) {
      character._lastRegenTime = DateTime.fromMillisecondsSinceEpoch(json['lastRegenTime']);
    }
    
    return character;
  }
  
  void dispose() {
    stopRegeneration();
  }
}
