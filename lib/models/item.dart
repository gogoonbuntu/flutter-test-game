enum ItemType { weapon, armor, potion }

class Item {
  final String name;
  final ItemType type;
  final int value;
  final String description;
  final Map<String, int> stats;

  const Item({
    required this.name,
    required this.type,
    required this.value,
    required this.description,
    required this.stats,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.toString(),
    'value': value,
    'description': description,
    'stats': stats,
  };
  
  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      type: ItemType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ItemType.potion,
      ),
      value: json['value'],
      description: json['description'],
      stats: Map<String, int>.from(json['stats']),
    );
  }
}
