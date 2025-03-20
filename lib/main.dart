import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/game_state.dart';
import 'screens/home_screen.dart';
import 'screens/character_creation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPG Stat Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _checkCharacterExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final bool hasCharacter = snapshot.data ?? false;
          return hasCharacter 
              ? const HomeScreen()
              : const CharacterCreationScreen();
        },
      ),
    );
  }

  Future<bool> _checkCharacterExists() async {
    final gameState = GameState();
    await gameState.loadGame();
    return gameState.character != null;
  }
}
