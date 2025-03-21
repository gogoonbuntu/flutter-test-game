class Race {
  final String name;
  final int hpBonus;
  final int mpBonus;
  final int atkBonus;
  final int defBonus;
  final int spdBonus;
  final String description;

  const Race({
    required this.name,
    required this.hpBonus,
    required this.mpBonus,
    required this.atkBonus,
    required this.defBonus,
    required this.spdBonus,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'hpBonus': hpBonus,
    'mpBonus': mpBonus,
    'atkBonus': atkBonus,
    'defBonus': defBonus,
    'spdBonus': spdBonus,
    'description': description,
  };
  
  static Race fromJson(Map<String, dynamic> json) {
    return Race(
      name: json['name'],
      hpBonus: json['hpBonus'],
      mpBonus: json['mpBonus'],
      atkBonus: json['atkBonus'],
      defBonus: json['defBonus'],
      spdBonus: json['spdBonus'],
      description: json['description'],
    );
  }

  static const List<Race> races = [
    Race(
      name: 'Human',
      hpBonus: 20,
      mpBonus: 20,
      atkBonus: 2,
      defBonus: 2,
      spdBonus: 2,
      description: 'Balanced race with no weaknesses',
    ),
    Race(
      name: 'Elf',
      hpBonus: 0,
      mpBonus: 50,
      atkBonus: 1,
      defBonus: 0,
      spdBonus: 5,
      description: 'High MP and Speed, but low HP',
    ),
    Race(
      name: 'Dwarf',
      hpBonus: 50,
      mpBonus: 0,
      atkBonus: 3,
      defBonus: 5,
      spdBonus: -2,
      description: 'High HP and Defense, but low Speed',
    ),
  ];
}
