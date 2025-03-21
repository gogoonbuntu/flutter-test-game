import 'character.dart';
import 'item.dart';
import 'skill.dart';
import 'pet.dart';
import '../services/notification_service.dart';

enum BenefitType {
  statIncrease,
  pet,
  shield,
  skillUnlock,
  itemGain,
  specialEffect
}

class Benefit {
  final String name;
  final String description;
  final BenefitType type;
  final Map<String, dynamic> effect;
  final int rarity; // 1-5, 5가 가장 희귀

  const Benefit({
    required this.name,
    required this.description,
    required this.type,
    required this.effect,
    this.rarity = 1,
  });

  void apply(Character character) {
    switch (type) {
      case BenefitType.statIncrease:
        _applyStatIncrease(character);
        break;
      case BenefitType.pet:
        _applyPet(character);
        break;
      case BenefitType.shield:
        _applyShield(character);
        break;
      case BenefitType.skillUnlock:
        _applySkillUnlock(character);
        break;
      case BenefitType.itemGain:
        _applyItemGain(character);
        break;
      case BenefitType.specialEffect:
        _applySpecialEffect(character);
        break;
    }
  }

  void _applyStatIncrease(Character character) {
    if (effect.containsKey('hp')) {
      character.maxHpBonus += effect['hp'] as int;
      character.hp += effect['hp'] as int;
    }
    if (effect.containsKey('mp')) {
      character.maxMpBonus += effect['mp'] as int;
      character.mp += effect['mp'] as int;
    }
    if (effect.containsKey('atk')) {
      character.atkBonus += effect['atk'] as int;
    }
    if (effect.containsKey('def')) {
      character.defBonus += effect['def'] as int;
    }
    if (effect.containsKey('spd')) {
      character.spdBonus += effect['spd'] as int;
    }
    if (effect.containsKey('skillProbability')) {
      character.skillProbability = (character.skillProbability + (effect['skillProbability'] as double)).clamp(0.0, 1.0);
    }
  }

  void _applyPet(Character character) {
    final petType = effect['type'] as String;
    final petLevel = effect['level'] as int;
    character.pets.add(Pet(
      type: petType,
      level: petLevel,
      bonusStats: effect['bonusStats'] as Map<String, int>,
    ));
  }

  void _applyShield(Character character) {
    character.shield = (character.shield + (effect['amount'] as int)).clamp(0, character.maxShield);
  }

  void _applySkillUnlock(Character character) {
    final skillName = effect['skillName'] as String;
    final notificationService = NotificationService();
    
    if (!character.skills.any((s) => s.name == skillName)) {
      character.skills.add(Skill.fromJson(effect['skill'] as Map<String, dynamic>));
      notificationService.addNotification('새로운 스킬을 습득했습니다: $skillName');
    } else {
      character.gold += 100;
      character.exp += 50;
      notificationService.addNotification('이미 습득한 스킬입니다. 대신 100골드와 50경험치를 획득했습니다.');
    }
  }

  void _applyItemGain(Character character) {
    final item = Item.fromJson(effect['item'] as Map<String, dynamic>);
    character.addItem(item);
  }

  void _applySpecialEffect(Character character) {
    if (effect.containsKey('regeneration')) {
      character.regenerationBonus += effect['regeneration'] as int;
    }
    if (effect.containsKey('criticalChance')) {
      character.criticalChance = (character.criticalChance + (effect['criticalChance'] as double)).clamp(0.0, 1.0);
    }
    if (effect.containsKey('criticalDamage')) {
      character.criticalDamage += effect['criticalDamage'] as double;
    }
  }
} 