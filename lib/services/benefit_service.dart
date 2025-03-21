import 'dart:math';
import '../models/benefit.dart';
import '../models/skill.dart';
import '../models/item.dart';

class BenefitService {
  static final List<Benefit> _allBenefits = [
    // 스탯 증가 베네핏 (레어리티 1-2)
    Benefit(
      name: 'HP 증가',
      description: '최대 HP가 20 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'hp': 20},
      rarity: 1,
    ),
    Benefit(
      name: 'MP 증가',
      description: '최대 MP가 10 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'mp': 10},
      rarity: 1,
    ),
    Benefit(
      name: '공격력 강화',
      description: '공격력이 5 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'atk': 5},
      rarity: 1,
    ),
    Benefit(
      name: '방어력 강화',
      description: '방어력이 5 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'def': 5},
      rarity: 1,
    ),
    Benefit(
      name: '민첩성 강화',
      description: '민첩성이 5 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'spd': 5},
      rarity: 1,
    ),
    Benefit(
      name: '대폭 HP 증가',
      description: '최대 HP가 50 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'hp': 50},
      rarity: 2,
    ),
    Benefit(
      name: '대폭 MP 증가',
      description: '최대 MP가 25 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'mp': 25},
      rarity: 2,
    ),
    Benefit(
      name: '초월적 HP 증가',
      description: '최대 HP가 100 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'hp': 100},
      rarity: 3,
    ),
    Benefit(
      name: '초월적 MP 증가',
      description: '최대 MP가 50 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'mp': 50},
      rarity: 3,
    ),
    Benefit(
      name: '대폭 공격력 강화',
      description: '공격력이 15 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'atk': 15},
      rarity: 3,
    ),
    Benefit(
      name: '대폭 방어력 강화',
      description: '방어력이 15 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'def': 15},
      rarity: 3,
    ),
    Benefit(
      name: '대폭 민첩성 강화',
      description: '민첩성이 15 증가합니다',
      type: BenefitType.statIncrease,
      effect: {'spd': 15},
      rarity: 3,
    ),

    // 펫 베네핏 (레어리티 3-5)
    Benefit(
      name: '작은 슬라임 펫',
      description: '작은 슬라임이 당신과 함께합니다. HP +10',
      type: BenefitType.pet,
      effect: {
        'type': 'slime',
        'level': 1,
        'bonusStats': {'hp': 10},
      },
      rarity: 3,
    ),
    Benefit(
      name: '새끼 드래곤',
      description: '어린 드래곤이 당신과 함께합니다. ATK +5',
      type: BenefitType.pet,
      effect: {
        'type': 'dragon',
        'level': 1,
        'bonusStats': {'atk': 5},
      },
      rarity: 4,
    ),
    Benefit(
      name: '요정',
      description: '요정이 당신과 함께합니다. MP 재생 +2',
      type: BenefitType.pet,
      effect: {
        'type': 'fairy',
        'level': 1,
        'bonusStats': {'mpRegen': 2},
      },
      rarity: 3,
    ),
    Benefit(
      name: '고대 드래곤',
      description: '강력한 드래곤이 당신과 함께합니다. ATK +15',
      type: BenefitType.pet,
      effect: {
        'type': 'ancient_dragon',
        'level': 1,
        'bonusStats': {'atk': 15},
      },
      rarity: 5,
    ),
    Benefit(
      name: '정령 여왕',
      description: '정령의 여왕이 당신과 함께합니다. MP 재생 +5',
      type: BenefitType.pet,
      effect: {
        'type': 'fairy_queen',
        'level': 1,
        'bonusStats': {'mpRegen': 5},
      },
      rarity: 5,
    ),
    Benefit(
      name: '골렘',
      description: '단단한 골렘이 당신과 함께합니다. DEF +10',
      type: BenefitType.pet,
      effect: {
        'type': 'golem',
        'level': 1,
        'bonusStats': {'def': 10},
      },
      rarity: 4,
    ),
    Benefit(
      name: '유니콘',
      description: '신비한 유니콘이 당신과 함께합니다. HP 재생 +3',
      type: BenefitType.pet,
      effect: {
        'type': 'unicorn',
        'level': 1,
        'bonusStats': {'hpRegen': 3},
      },
      rarity: 4,
    ),
    Benefit(
      name: '피닉스',
      description: '불사조가 당신과 함께합니다. HP 재생 +4, MP 재생 +2',
      type: BenefitType.pet,
      effect: {
        'type': 'phoenix',
        'level': 1,
        'bonusStats': {'hpRegen': 4, 'mpRegen': 2},
      },
      rarity: 5,
    ),
    Benefit(
      name: '그리폰',
      description: '그리폰이 당신과 함께합니다. ATK +8, SPD +5',
      type: BenefitType.pet,
      effect: {
        'type': 'griffin',
        'level': 1,
        'bonusStats': {'atk': 8, 'spd': 5},
      },
      rarity: 4,
    ),

    // 방어막 베네핏 (레어리티 2-3)
    Benefit(
      name: '마법 방어막',
      description: '30의 방어막을 얻습니다',
      type: BenefitType.shield,
      effect: {'amount': 30},
      rarity: 2,
    ),
    Benefit(
      name: '강화된 방어막',
      description: '50의 방어막을 얻습니다',
      type: BenefitType.shield,
      effect: {'amount': 50},
      rarity: 3,
    ),
    Benefit(
      name: '신성한 방어막',
      description: '80의 방어막을 얻고 방어막 최대치가 50 증가합니다',
      type: BenefitType.shield,
      effect: {'amount': 80, 'maxIncrease': 50},
      rarity: 4,
    ),
    Benefit(
      name: '마법 보호막',
      description: '40의 방어막을 얻고 마법 저항이 증가합니다',
      type: BenefitType.shield,
      effect: {'amount': 40, 'magicResist': 10},
      rarity: 3,
    ),

    // 스킬 해금 베네핏 (레어리티 3-5)
    Benefit(
      name: '번개 마법 습득',
      description: '번개 마법을 배웁니다',
      type: BenefitType.skillUnlock,
      effect: {
        'skillName': 'Lightning Bolt',
        'skill': {
          'name': 'Lightning Bolt',
          'damage': 30,
          'mpCost': 25,
          'probability': 0.8,
          'description': '적에게 번개 피해를 입힙니다',
        },
      },
      rarity: 3,
    ),
    Benefit(
      name: '치유 마법 습득',
      description: '치유 마법을 배웁니다',
      type: BenefitType.skillUnlock,
      effect: {
        'skillName': 'Healing Light',
        'skill': {
          'name': 'Healing Light',
          'damage': 0,
          'mpCost': 30,
          'probability': 1.0,
          'description': 'HP를 회복합니다',
          'effect': {'heal': 50},
        },
      },
      rarity: 4,
    ),
    Benefit(
      name: '화염 폭발',
      description: '강력한 화염 마법을 배웁니다',
      type: BenefitType.skillUnlock,
      effect: {
        'skillName': 'Fire Explosion',
        'skill': {
          'name': 'Fire Explosion',
          'damage': 50,
          'mpCost': 40,
          'probability': 0.7,
          'description': '적에게 강력한 화염 피해를 입힙니다',
        },
      },
      rarity: 4,
    ),
    Benefit(
      name: '얼음 폭풍',
      description: '광역 얼음 마법을 배웁니다',
      type: BenefitType.skillUnlock,
      effect: {
        'skillName': 'Ice Storm',
        'skill': {
          'name': 'Ice Storm',
          'damage': 35,
          'mpCost': 35,
          'probability': 0.8,
          'description': '적에게 얼음 피해를 입히고 속도를 감소시킵니다',
          'effect': {'slow': 0.2},
        },
      },
      rarity: 4,
    ),
    Benefit(
      name: '신성한 검',
      description: '신성한 힘이 깃든 검술을 배웁니다',
      type: BenefitType.skillUnlock,
      effect: {
        'skillName': 'Holy Blade',
        'skill': {
          'name': 'Holy Blade',
          'damage': 40,
          'mpCost': 30,
          'probability': 0.9,
          'description': '신성한 피해를 입히고 체력을 회복합니다',
          'effect': {'heal': 20},
        },
      },
      rarity: 4,
    ),
    Benefit(
      name: '궁극의 힘',
      description: '강력한 궁극기를 배웁니다',
      type: BenefitType.skillUnlock,
      effect: {
        'skillName': 'Ultimate Power',
        'skill': {
          'name': 'Ultimate Power',
          'damage': 100,
          'mpCost': 80,
          'probability': 0.6,
          'description': '엄청난 피해를 입히지만 MP 소모가 큽니다',
        },
      },
      rarity: 5,
    ),
    Benefit(
      name: '생명력 흡수',
      description: '적의 생명력을 흡수하는 스킬을 배웁니다',
      type: BenefitType.skillUnlock,
      effect: {
        'skillName': 'Life Drain',
        'skill': {
          'name': 'Life Drain',
          'damage': 25,
          'mpCost': 30,
          'probability': 0.8,
          'description': '적에게 피해를 입히고 그 절반만큼 체력을 회복합니다',
          'effect': {'drainRatio': 0.5},
        },
      },
      rarity: 4,
    ),

    // 아이템 획득 베네핏 (레어리티 2-5)
    Benefit(
      name: '회복 포션 발견',
      description: '강력한 회복 포션을 얻습니다',
      type: BenefitType.itemGain,
      effect: {
        'item': {
          'name': 'Greater Healing Potion',
          'type': 'potion',
          'value': 100,
          'description': 'HP를 100 회복합니다',
          'stats': {'HP': 100},
        },
      },
      rarity: 2,
    ),
    Benefit(
      name: '마나 포션 발견',
      description: '강력한 마나 포션을 얻습니다',
      type: BenefitType.itemGain,
      effect: {
        'item': {
          'name': 'Greater Mana Potion',
          'type': 'potion',
          'value': 100,
          'description': 'MP를 50 회복합니다',
          'stats': {'MP': 50},
        },
      },
      rarity: 2,
    ),
    Benefit(
      name: '전설의 검 발견',
      description: '강력한 전설의 검을 얻습니다',
      type: BenefitType.itemGain,
      effect: {
        'item': {
          'name': 'Legendary Sword',
          'type': 'weapon',
          'value': 1000,
          'description': '전설적인 힘이 깃든 검입니다',
          'stats': {'ATK': 30},
        },
      },
      rarity: 5,
    ),
    Benefit(
      name: '드래곤 갑옷 발견',
      description: '드래곤의 비늘로 만든 갑옷을 얻습니다',
      type: BenefitType.itemGain,
      effect: {
        'item': {
          'name': 'Dragon Scale Armor',
          'type': 'armor',
          'value': 1000,
          'description': '드래곤의 비늘로 만든 강력한 갑옷입니다',
          'stats': {'DEF': 25, 'HP': 50},
        },
      },
      rarity: 5,
    ),

    // 특수 효과 베네핏 (레어리티 3-5)
    Benefit(
      name: '생명력 재생 강화',
      description: 'HP 재생이 3 증가합니다',
      type: BenefitType.specialEffect,
      effect: {'regeneration': 3},
      rarity: 3,
    ),
    Benefit(
      name: '치명타 확률 증가',
      description: '치명타 확률이 5% 증가합니다',
      type: BenefitType.specialEffect,
      effect: {'criticalChance': 0.05},
      rarity: 3,
    ),
    Benefit(
      name: '치명타 피해 증가',
      description: '치명타 피해가 20% 증가합니다',
      type: BenefitType.specialEffect,
      effect: {'criticalDamage': 0.2},
      rarity: 4,
    ),
    Benefit(
      name: '생명력 초월',
      description: 'HP 재생이 8 증가합니다',
      type: BenefitType.specialEffect,
      effect: {'regeneration': 8},
      rarity: 4,
    ),
    Benefit(
      name: '치명적인 일격',
      description: '치명타 확률이 15% 증가합니다',
      type: BenefitType.specialEffect,
      effect: {'criticalChance': 0.15},
      rarity: 4,
    ),
    Benefit(
      name: '파괴자의 힘',
      description: '치명타 피해가 50% 증가합니다',
      type: BenefitType.specialEffect,
      effect: {'criticalDamage': 0.5},
      rarity: 5,
    ),
    Benefit(
      name: '마나 순환',
      description: '스킬 사용 시 20% 확률로 MP 소모가 없습니다',
      type: BenefitType.specialEffect,
      effect: {'mpSaveChance': 0.2},
      rarity: 5,
    ),
    Benefit(
      name: '이중 공격',
      description: '일반 공격 시 30% 확률로 한번 더 공격합니다',
      type: BenefitType.specialEffect,
      effect: {'doubleAttackChance': 0.3},
      rarity: 4,
    ),
    Benefit(
      name: '반사 피해',
      description: '받은 피해의 20%를 적에게 되돌립니다',
      type: BenefitType.specialEffect,
      effect: {'damageReflect': 0.2},
      rarity: 4,
    ),

    // 조합 베네핏 (레어리티 3)
    Benefit(
      name: '마력 강화',
      description: 'MP와 스킬 성공률이 증가합니다',
      type: BenefitType.statIncrease,
      effect: {
        'mp': 20,
        'skillProbability': 0.1,
      },
      rarity: 3,
    ),
    Benefit(
      name: '전사의 기운',
      description: 'HP와 공격력이 증가합니다',
      type: BenefitType.statIncrease,
      effect: {
        'hp': 30,
        'atk': 8,
      },
      rarity: 3,
    ),
    Benefit(
      name: '수호자의 축복',
      description: 'HP와 방어력이 증가합니다',
      type: BenefitType.statIncrease,
      effect: {
        'hp': 40,
        'def': 10,
      },
      rarity: 3,
    ),
  ];

  static List<Benefit> getRandomBenefits(int count, {bool sameRarity = false}) {
    if (_allBenefits.isEmpty) return [];

    if (sameRarity) {
      // 랜덤하게 레벨을 선택
      final random = Random();
      final rarity = random.nextInt(5) + 1;
      
      // 선택된 레벨의 베네핏만 필터링
      final sameRarityBenefits = _allBenefits.where((b) => b.rarity == rarity).toList();
      
      // 필터링된 베네핏에서 랜덤하게 선택
      final selectedBenefits = <Benefit>[];
      while (selectedBenefits.length < count && sameRarityBenefits.isNotEmpty) {
        final index = random.nextInt(sameRarityBenefits.length);
        selectedBenefits.add(sameRarityBenefits.removeAt(index));
      }
      
      return selectedBenefits;
    } else {
      // 기존 로직: 모든 베네핏에서 랜덤하게 선택
      final random = Random();
      final selectedBenefits = <Benefit>[];
      final availableBenefits = List<Benefit>.from(_allBenefits);

      while (selectedBenefits.length < count && availableBenefits.isNotEmpty) {
        final index = random.nextInt(availableBenefits.length);
        selectedBenefits.add(availableBenefits.removeAt(index));
      }

      return selectedBenefits;
    }
  }
} 