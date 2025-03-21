class Skill {
  final String name;
  final int damage;
  final int mpCost;
  final double probability;
  final String description;
  final int hitCount;
  final Map<String, dynamic>? effect;
  final int cooldown; // 쿨타임 (초)
  final DateTime? lastUsedTime; // 마지막 사용 시간

  const Skill({
    required this.name,
    required this.damage,
    required this.mpCost,
    required this.probability,
    required this.description,
    this.hitCount = 1,
    this.effect,
    this.cooldown = 0,
    this.lastUsedTime,
  });

  bool get isOnCooldown {
    if (cooldown == 0 || lastUsedTime == null) return false;
    return DateTime.now().difference(lastUsedTime!).inSeconds < cooldown;
  }

  int get remainingCooldown {
    if (cooldown == 0 || lastUsedTime == null) return 0;
    final remaining = cooldown - DateTime.now().difference(lastUsedTime!).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  Skill use() {
    return Skill(
      name: name,
      damage: damage,
      mpCost: mpCost,
      probability: probability,
      description: description,
      hitCount: hitCount,
      effect: effect,
      cooldown: cooldown,
      lastUsedTime: DateTime.now(),
    );
  }

  Skill reduceCooldown(int seconds) {
    if (lastUsedTime == null) return this;
    return Skill(
      name: name,
      damage: damage,
      mpCost: mpCost,
      probability: probability,
      description: description,
      hitCount: hitCount,
      effect: effect,
      cooldown: cooldown,
      lastUsedTime: lastUsedTime!.subtract(Duration(seconds: seconds)),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'damage': damage,
    'mpCost': mpCost,
    'probability': probability,
    'description': description,
    'hitCount': hitCount,
    'effect': effect,
    'cooldown': cooldown,
    'lastUsedTime': lastUsedTime?.millisecondsSinceEpoch,
  };
  
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'],
      damage: json['damage'],
      mpCost: json['mpCost'],
      probability: json['probability'],
      description: json['description'],
      hitCount: json['hitCount'] ?? 1,
      effect: json['effect'],
      cooldown: json['cooldown'] ?? 0,
      lastUsedTime: json['lastUsedTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['lastUsedTime'])
          : null,
    );
  }
}
