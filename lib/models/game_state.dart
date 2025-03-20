import 'package:flutter/foundation.dart';
import 'character.dart';
import 'item.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameState extends ChangeNotifier {
  Character? character;
  List<Item> inventory = [];
  static final GameState _instance = GameState._internal();

  factory GameState() {
    return _instance;
  }

  GameState._internal();

  Future<void> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedCharacter = prefs.getString('character');
    final String? savedInventory = prefs.getString('inventory');

    if (savedCharacter != null) {
      final Map<String, dynamic> characterJson = json.decode(savedCharacter);
      character = Character.fromJson(characterJson);
    }

    if (savedInventory != null) {
      final List<dynamic> inventoryJson = json.decode(savedInventory);
      inventory = inventoryJson.map((item) => Item.fromJson(item)).toList();
    }
    notifyListeners();
  }

  Future<void> saveGame() async {
    final prefs = await SharedPreferences.getInstance();
    if (character != null) {
      await prefs.setString('character', json.encode(character!.toJson()));
    }
    await prefs.setString('inventory', json.encode(inventory.map((item) => item.toJson()).toList()));
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
