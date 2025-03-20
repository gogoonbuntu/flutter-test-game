import 'package:flutter/material.dart';
import 'character_screen.dart';
import 'inventory_screen.dart';
import 'battle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
