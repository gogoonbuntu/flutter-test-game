import 'dart:async';
import 'race.dart';
import 'job.dart';
import 'skill.dart';
import 'item.dart';
import 'benefit.dart';
import 'pet.dart';

class Character {
  int id = 0; // Unique identifier for character management
  final String name;
  final String avatar; // Avatar image name
  final Race race;
  final Job job;
  int level;
  int exp;
  int gold;
  int hp;
  int maxHp;
  int mp;
  int maxMp;
  int atk;
  int def;
  int spd;
  double skillProbability;
  double criticalChance;
  double criticalDamage;
  int regenerationBonus;
  int maxShield;
  int shield;
  List<Skill> skills;
  List<Item> inventory;
  List<Pet> pets;
  int maxHpBonus;
  int maxMpBonus;
  int atkBonus;
  int defBonus;
  int spdBonus;
  DateTime _lastRegenTime = DateTime.now();
  Timer? _regenTimer;

  // Regeneration rates per minute
  int get hpRegenRate => 5 + (level ~/ 5) + regenerationBonus;
  int get mpRegenRate => 3 + (level ~/ 5) + (regenerationBonus ~/ 2);

  Character({
    required this.name,
    required this.race,
    required this.job,
    this.avatar = 'default_avatar.png',
    this.id = 0,
    this.level = 1,
    this.exp = 0,
    this.gold = 0,
    this.maxHpBonus = 0,
    this.maxMpBonus = 0,
    this.atkBonus = 0,
    this.defBonus = 0,
    this.spdBonus = 0,
    this.skillProbability = 1.0,
    this.criticalChance = 0.05,
    this.criticalDamage = 1.5,
    this.regenerationBonus = 0,
    this.maxShield = 0,
    this.shield = 0,
    List<Skill>? skills,
    List<Item>? inventory,
    List<Pet>? pets,
  }) : 
    skills = skills ?? [],
    inventory = inventory ?? [],
    pets = pets ?? [],
    hp = RaceData.raceData[race]!.hpBonus + JobData.jobData[job]!.hpBonus + 100,
    maxHp = RaceData.raceData[race]!.hpBonus + JobData.jobData[job]!.hpBonus + 100,
    mp = RaceData.raceData[race]!.mpBonus + JobData.jobData[job]!.mpBonus + 50,
    maxMp = RaceData.raceData[race]!.mpBonus + JobData.jobData[job]!.mpBonus + 50,
    atk = RaceData.raceData[race]!.atkBonus + JobData.jobData[job]!.atkBonus + 10,
    def = RaceData.raceData[race]!.defBonus + JobData.jobData[job]!.defBonus + 5,
    spd = RaceData.raceData[race]!.spdBonus + JobData.jobData[job]!.spdBonus + 5 {
    // Initialize with job skills
    this.skills.addAll(JobData.jobData[job]!.skills);
    
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
    while (exp >= _getExpForNextLevel()) {
      levelUp();
    }
  }

  void levelUp() {
    level++;
    exp -= _getExpForNextLevel();
    
    // 스탯 증가
    maxHp += 20;
    maxMp += 10;
    atk += 2;
    def += 1;
    spd += 1;
    
    // HP/MP 회복
    hp = maxHp;
    mp = maxMp;
    
    // Check for new skills
    learnNewSkill();
  }

  int _getExpForNextLevel() {
    return level * 100;
  }

  bool useSkill(Skill skill) {
    if (mp >= skill.mpCost && !skill.isOnCooldown) {
      mp -= skill.mpCost;
      final updatedSkill = skill.use();
      final index = skills.indexWhere((s) => s.name == skill.name);
      if (index != -1) {
        skills[index] = updatedSkill;
      }
      return true;
    }
    return false;
  }

  void reduceSkillCooldowns(int seconds) {
    skills = skills.map((skill) => skill.reduceCooldown(seconds)).toList();
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

  void useItem(Item item) {
    if (item.type == ItemType.potion) {
      if (item.stats.containsKey('HP')) {
        hp = (hp + item.stats['HP']!).clamp(0, maxHp);
      }
      if (item.stats.containsKey('MP')) {
        mp = (mp + item.stats['MP']!).clamp(0, maxMp);
      }
    }
    inventory.remove(item);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'race': race.toString(),
      'job': job.toString(),
      'level': level,
      'exp': exp,
      'gold': gold,
      'hp': hp,
      'maxHp': maxHp,
      'mp': mp,
      'maxMp': maxMp,
      'atk': atk,
      'def': def,
      'spd': spd,
      'skillProbability': skillProbability,
      'criticalChance': criticalChance,
      'criticalDamage': criticalDamage,
      'regenerationBonus': regenerationBonus,
      'maxShield': maxShield,
      'shield': shield,
      'maxHpBonus': maxHpBonus,
      'maxMpBonus': maxMpBonus,
      'atkBonus': atkBonus,
      'defBonus': defBonus,
      'spdBonus': spdBonus,
      'skills': skills.map((s) => s.toJson()).toList(),
      'inventory': inventory.map((i) => i.toJson()).toList(),
      'pets': pets.map((p) => p.toJson()).toList(),
      'lastRegenTime': _lastRegenTime.millisecondsSinceEpoch,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    final character = Character(
      id: json['id'] ?? 0,
      name: json['name'],
      avatar: json['avatar'] ?? 'default_avatar.png',
      race: Race.values.firstWhere((e) => e.toString() == json['race']),
      job: Job.values.firstWhere((e) => e.toString() == json['job']),
      level: json['level'],
      exp: json['exp'],
      gold: json['gold'],
      maxHpBonus: json['maxHpBonus'] ?? 0,
      maxMpBonus: json['maxMpBonus'] ?? 0,
      atkBonus: json['atkBonus'] ?? 0,
      defBonus: json['defBonus'] ?? 0,
      spdBonus: json['spdBonus'] ?? 0,
      skillProbability: json['skillProbability'],
      criticalChance: json['criticalChance'] ?? 0.05,
      criticalDamage: json['criticalDamage'] ?? 1.5,
      regenerationBonus: json['regenerationBonus'] ?? 0,
      maxShield: json['maxShield'] ?? 0,
      shield: json['shield'] ?? 0,
      skills: (json['skills'] as List).map((s) => Skill.fromJson(s as Map<String, dynamic>)).toList(),
      inventory: (json['inventory'] as List).map((i) => Item.fromJson(i as Map<String, dynamic>)).toList(),
      pets: (json['pets'] as List).map((p) => Pet.fromJson(p as Map<String, dynamic>)).toList(),
    );
    
    if (json.containsKey('lastRegenTime')) {
      character._lastRegenTime = DateTime.fromMillisecondsSinceEpoch(json['lastRegenTime']);
    }
    
    return character;
  }
  
  void dispose() {
    stopRegeneration();
  }
}
