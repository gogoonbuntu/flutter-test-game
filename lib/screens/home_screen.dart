import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/character_manager.dart';
import '../services/notification_service.dart';
import 'character_screen.dart';
import 'inventory_screen.dart';
import 'battle_screen.dart';
import 'character_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CharacterManager _characterManager = CharacterManager();
  final NotificationService _notificationService = NotificationService();
  Character? _activeCharacter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    setState(() {
      _isLoading = true;
    });

    await _characterManager.loadCharacters();
    
    setState(() {
      _activeCharacter = _characterManager.activeCharacter;
      _isLoading = false;
    });

    if (_activeCharacter == null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CharacterManagementScreen(),
          ),
        );
      }
    } else {
      // Start HP/MP regeneration
      _activeCharacter!.startRegeneration();
      _notificationService.addNotification('Welcome back, ${_activeCharacter!.name}!');
    }
  }

  void _switchCharacter() {
    // Stop regeneration before switching
    if (_activeCharacter != null) {
      _activeCharacter!.stopRegeneration();
    }
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CharacterManagementScreen(),
      ),
    );
  }

  @override
  void dispose() {
    // Stop regeneration when leaving the screen
    if (_activeCharacter != null) {
      _activeCharacter!.stopRegeneration();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Switch Character',
            onPressed: _switchCharacter,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Character info card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Character avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        _activeCharacter!.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Character details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _activeCharacter!.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_activeCharacter!.race.name} ${_activeCharacter!.job.name}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Level: ${_activeCharacter!.level}'),
                          const SizedBox(height: 4),
                          // HP Bar
                          _buildStatBar(
                            'HP',
                            _activeCharacter!.hp,
                            _activeCharacter!.maxHp,
                            Colors.red,
                          ),
                          const SizedBox(height: 4),
                          // MP Bar
                          _buildStatBar(
                            'MP',
                            _activeCharacter!.mp,
                            _activeCharacter!.maxMp,
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Menu buttons
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuButton(
                    context,
                    'Character Stats',
                    Icons.person,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CharacterScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuButton(
                    context,
                    'Inventory',
                    Icons.inventory,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InventoryScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuButton(
                    context,
                    'Battle',
                    Icons.sports_kabaddi,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BattleScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int current, int max, Color color) {
    final percentage = current / max;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('$current / $max'),
          ],
        ),
        const SizedBox(height: 2),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
