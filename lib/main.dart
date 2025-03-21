import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/character_manager.dart';
import 'screens/home_screen.dart';
import 'screens/character_management_screen.dart';
import 'widgets/notification_panel.dart';
import 'services/notification_service.dart';
import 'services/localization_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalizationService().initialize();
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
      home: AppScaffold(
        child: FutureBuilder(
          future: _checkActiveCharacterExists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final bool hasActiveCharacter = snapshot.data ?? false;
            return hasActiveCharacter 
                ? const HomeScreen()
                : const CharacterManagementScreen();
          },
        ),
      ),
    );
  }

  Future<bool> _checkActiveCharacterExists() async {
    final characterManager = CharacterManager();
    await characterManager.loadCharacters();
    return characterManager.activeCharacter != null;
  }
}

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize notification service with a welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().addNotification('Welcome to RPG Stat Game!');
    });

    return Scaffold(
      body: Column(
        children: [
          // Main content area
          Expanded(child: child),
          
          // Notification panel at the bottom
          const NotificationPanel(height: 150),
        ],
      ),
    );
  }
}
