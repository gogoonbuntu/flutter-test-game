class Pet {
  final String type;
  final int level;
  final Map<String, int> bonusStats;

  const Pet({
    required this.type,
    required this.level,
    required this.bonusStats,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'level': level,
      'bonusStats': bonusStats,
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      type: json['type'] as String,
      level: json['level'] as int,
      bonusStats: Map<String, int>.from(json['bonusStats'] as Map),
    );
  }
} 