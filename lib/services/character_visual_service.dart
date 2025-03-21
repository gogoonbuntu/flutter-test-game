import 'package:flutter/material.dart';
import '../models/race.dart';
import '../models/job.dart';

class CharacterVisualService {
  static final CharacterVisualService _instance = CharacterVisualService._internal();
  factory CharacterVisualService() => _instance;
  CharacterVisualService._internal();

  String getCharacterImage(Race race, Job job) {
    // 기본 이미지 경로
    final String basePath = 'assets/images/characters';
    
    // 종족별 기본 이미지
    final String raceImage = _getRaceImage(race);
    
    // 직업별 이미지
    final String jobImage = _getJobImage(job);
    
    // 최종 이미지 경로
    return '$basePath/$raceImage/$jobImage.png';
  }

  String _getRaceImage(Race race) {
    switch (race) {
      case Race.human:
        return 'human';
      case Race.elf:
        return 'elf';
      case Race.dwarf:
        return 'dwarf';
      case Race.orc:
        return 'orc';
      case Race.undead:
        return 'undead';
      default:
        return 'human';
    }
  }

  String _getJobImage(Job job) {
    switch (job) {
      case Job.warrior:
        return 'warrior';
      case Job.mage:
        return 'mage';
      case Job.archer:
        return 'archer';
      case Job.rogue:
        return 'rogue';
      case Job.priest:
        return 'priest';
      case Job.paladin:
        return 'paladin';
      default:
        return 'warrior';
    }
  }
} 