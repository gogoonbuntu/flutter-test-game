class Character {
  int level;
  int hp;
  int mp;
  int atk;
  int def;
  int spd;
  int exp;
  int gold;

  Character({
    this.level = 1,
    this.hp = 100,
    this.mp = 50,
    this.atk = 10,
    this.def = 10,
    this.spd = 10,
    this.exp = 0,
    this.gold = 0,
  });

  void trainStat(String stat) {
    switch (stat) {
      case 'HP':
        hp += 10;
        break;
      case 'MP':
        mp += 5;
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
    }
    exp += 10;
    if (exp >= 100) {
      levelUp();
    }
  }

  void levelUp() {
    level++;
    exp = 0;
    gold += 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'hp': hp,
      'mp': mp,
      'atk': atk,
      'def': def,
      'spd': spd,
      'exp': exp,
      'gold': gold,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      level: json['level'],
      hp: json['hp'],
      mp: json['mp'],
      atk: json['atk'],
      def: json['def'],
      spd: json['spd'],
      exp: json['exp'],
      gold: json['gold'],
    );
  }
}
