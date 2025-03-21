import 'dart:ui';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  late String _currentLocale;

  void initialize() {
    _currentLocale = window.locale.languageCode;
  }

  String get currentLocale => _currentLocale;

  String translate(String key) {
    if (_currentLocale == 'ko') {
      return _koTranslations[key] ?? key;
    }
    return key;
  }

  static final Map<String, String> _koTranslations = {
    // 베네핏 관련
    'HP Increase': 'HP 증가',
    'MP Increase': 'MP 증가',
    'ATK Increase': '공격력 증가',
    'DEF Increase': '방어력 증가',
    'SPD Increase': '민첩성 증가',
    'Skill Probability Increase': '스킬 성공률 증가',
    'Victory!': '승리!',
    'Select a benefit': '베네핏을 선택하세요',
    'You defeated': '처치함',
    'Gained': '획득',
    'EXP': '경험치',
    'Gold': '골드',
    'Battle': '전투',
    'Please create a character first': '캐릭터를 먼저 생성해주세요',
    'Battle started': '전투가 시작되었습니다',
    'Not enough MP!': 'MP가 부족합니다!',
    'Used': '사용함',
    'Dealt': '피해',
    'damage': '피해를 입힘',
    'missed': '빗나감',
    'attacks': '공격',
    'Got item': '아이템 획득',
    'Continue': '계속하기',
    'Return': '돌아가기',

    // 스킬 이름
    'Lightning Bolt': '번개 화살',
    'Healing Light': '치유의 빛',
    'Fire Explosion': '화염 폭발',
    'Ice Storm': '얼음 폭풍',
    'Holy Blade': '성스러운 검',
    'Ultimate Power': '궁극의 힘',
    'Life Drain': '생명력 흡수',

    // 아이템 이름
    'Greater Healing Potion': '상급 회복 물약',
    'Greater Mana Potion': '상급 마나 물약',
    'Legendary Sword': '전설의 검',
    'Dragon Scale Armor': '드래곤 비늘 갑옷',

    // 펫 이름
    'Slime': '슬라임',
    'Dragon': '드래곤',
    'Fairy': '요정',
    'Ancient Dragon': '고대 드래곤',
    'Fairy Queen': '정령 여왕',
    'Golem': '골렘',
    'Unicorn': '유니콘',
    'Phoenix': '피닉스',
    'Griffin': '그리폰',
  };
} 