import 'package:flutter/foundation.dart';
import 'character.dart';
import 'item.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'character_manager.dart';

class GameState extends ChangeNotifier {
  Character? character;
  List<Item> inventory = [];
  static final GameState _instance = GameState._internal();
  final CharacterManager _characterManager = CharacterManager();

  factory GameState() {
    return _instance;
  }

  GameState._internal();

  Future<void> loadGame() async {
    await _characterManager.loadCharacters();
    character = _characterManager.activeCharacter;
    
    if (character != null) {
      inventory = character!.inventory;
    }
    
    notifyListeners();
  }

  Future<void> saveGame() async {
    if (character != null) {
      character!.inventory = inventory;
      _characterManager.updateCharacter(character!);
      await _characterManager.saveCharacters();
    }
  }

  void addItem(Item item) {
    inventory.add(item);
    saveGame();
    notifyListeners();
  }

  void removeItem(Item item) {
    inventory.remove(item);
    saveGame();
    notifyListeners();
  }

  void gainExp(int amount) {
    if (character != null) {
      character!.gainExp(amount);
      saveGame();
      notifyListeners();
    }
  }

  void gainGold(int amount) {
    if (character != null) {
      character!.gold += amount;
      saveGame();
      notifyListeners();
    }
  }

  void useItem(Item item) {
    if (character != null && inventory.contains(item)) {
      switch (item.type) {
        case ItemType.potion:
          if (item.stats.containsKey('HP')) {
            character!.hp = (character!.hp + item.stats['HP']!).clamp(0, character!.maxHp);
          }
          if (item.stats.containsKey('MP')) {
            character!.mp = (character!.mp + item.stats['MP']!).clamp(0, character!.maxMp);
          }
          removeItem(item);
          break;
        case ItemType.weapon:
        case ItemType.armor:
          // Equipment logic will be implemented later
          break;
      }
      notifyListeners();
    }
  }
}
