class Skill {
  final String name;
  final int damage;
  final int mpCost;
  final double probability;
  final String description;

  const Skill({
    required this.name,
    required this.damage,
    required this.mpCost,
    required this.probability,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'damage': damage,
    'mpCost': mpCost,
    'probability': probability,
    'description': description,
  };
}
