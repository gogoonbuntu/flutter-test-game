enum Race {
  human,
  elf,
  dwarf,
  orc,
  undead
}

class RaceData {
  final String name;
  final int hpBonus;
  final int mpBonus;
  final int atkBonus;
  final int defBonus;
  final int spdBonus;
  final String description;

  const RaceData({
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
  
  static RaceData fromJson(Map<String, dynamic> json) {
    return RaceData(
      name: json['name'],
      hpBonus: json['hpBonus'],
      mpBonus: json['mpBonus'],
      atkBonus: json['atkBonus'],
      defBonus: json['defBonus'],
      spdBonus: json['spdBonus'],
      description: json['description'],
    );
  }

  static const Map<Race, RaceData> raceData = {
    Race.human: RaceData(
      name: 'Human',
      hpBonus: 20,
      mpBonus: 20,
      atkBonus: 2,
      defBonus: 2,
      spdBonus: 2,
      description: 'Balanced race with no weaknesses',
    ),
    Race.elf: RaceData(
      name: 'Elf',
      hpBonus: 0,
      mpBonus: 50,
      atkBonus: 1,
      defBonus: 0,
      spdBonus: 5,
      description: 'High MP and Speed, but low HP',
    ),
    Race.dwarf: RaceData(
      name: 'Dwarf',
      hpBonus: 50,
      mpBonus: 0,
      atkBonus: 3,
      defBonus: 5,
      spdBonus: -2,
      description: 'High HP and Defense, but low Speed',
    ),
    Race.orc: RaceData(
      name: 'Orc',
      hpBonus: 40,
      mpBonus: 0,
      atkBonus: 5,
      defBonus: 3,
      spdBonus: 0,
      description: 'Strong physical attacker with high HP',
    ),
    Race.undead: RaceData(
      name: 'Undead',
      hpBonus: 30,
      mpBonus: 30,
      atkBonus: 2,
      defBonus: 2,
      spdBonus: 1,
      description: 'Balanced undead with special abilities',
    ),
  };
}
