import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character.dart';
import '../services/notification_service.dart';

class CharacterManager {
  static final CharacterManager _instance = CharacterManager._internal();
  factory CharacterManager() => _instance;
  CharacterManager._internal();

  final List<Character> _characters = [];
  Character? _activeCharacter;
  final NotificationService _notificationService = NotificationService();

  List<Character> get characters => List.unmodifiable(_characters);
  Character? get activeCharacter => _activeCharacter;

  Future<void> loadCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final characterListJson = prefs.getStringList('characters') ?? [];
    final activeCharacterId = prefs.getInt('activeCharacterId');

    _characters.clear();
    for (final charJson in characterListJson) {
      final character = Character.fromJson(json.decode(charJson));
      _characters.add(character);
      
      if (activeCharacterId != null && character.id == activeCharacterId) {
        _activeCharacter = character;
      }
    }

    // If no active character but we have characters, set the first one as active
    if (_activeCharacter == null && _characters.isNotEmpty) {
      _activeCharacter = _characters.first;
    }
  }

  Future<void> saveCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final characterListJson = _characters.map((c) => json.encode(c.toJson())).toList();
    
    await prefs.setStringList('characters', characterListJson);
    
    if (_activeCharacter != null) {
      await prefs.setInt('activeCharacterId', _activeCharacter!.id);
    }
  }

  void addCharacter(Character character) {
    // Ensure unique ID
    if (_characters.isEmpty) {
      character.id = 1;
    } else {
      character.id = _characters.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
    }
    
    _characters.add(character);
    
    // If this is the first character, make it active
    if (_characters.length == 1) {
      _activeCharacter = character;
    }
    
    _notificationService.addNotification('New character created: ${character.name}');
    saveCharacters();
  }

  void setActiveCharacter(Character character) {
    if (_characters.contains(character)) {
      _activeCharacter = character;
      _notificationService.addNotification('Switched to character: ${character.name}');
      saveCharacters();
    }
  }

  void deleteCharacter(Character character) {
    if (_characters.contains(character)) {
      _characters.remove(character);
      
      // If we deleted the active character, set a new one if available
      if (_activeCharacter == character && _characters.isNotEmpty) {
        _activeCharacter = _characters.first;
      } else if (_characters.isEmpty) {
        _activeCharacter = null;
      }
      
      _notificationService.addNotification('Character deleted: ${character.name}');
      saveCharacters();
    }
  }

  void updateCharacter(Character character) {
    final index = _characters.indexWhere((c) => c.id == character.id);
    if (index != -1) {
      _characters[index] = character;
      
      // If this was the active character, update the reference
      if (_activeCharacter?.id == character.id) {
        _activeCharacter = character;
      }
      
      saveCharacters();
    }
  }
}
