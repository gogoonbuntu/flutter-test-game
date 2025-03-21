class Skill {
  final String name;
  final int damage;
  final int mpCost;
  final double probability;
  final String description;
  final int hitCount;
  final Map<String, dynamic>? effect;

  const Skill({
    required this.name,
    required this.damage,
    required this.mpCost,
    required this.probability,
    required this.description,
    this.hitCount = 1,
    this.effect,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'damage': damage,
    'mpCost': mpCost,
    'probability': probability,
    'description': description,
    'hitCount': hitCount,
    'effect': effect,
  };
  
  static Skill fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'],
      damage: json['damage'],
      mpCost: json['mpCost'],
      probability: json['probability'],
      description: json['description'],
      hitCount: json['hitCount'] ?? 1,
      effect: json['effect'] != null ? Map<String, dynamic>.from(json['effect']) : null,
    );
  }
}
