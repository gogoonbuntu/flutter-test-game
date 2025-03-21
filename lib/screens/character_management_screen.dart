import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/character_manager.dart';
import '../services/notification_service.dart';
import 'character_creation_screen.dart';
import 'home_screen.dart';

class CharacterManagementScreen extends StatefulWidget {
  const CharacterManagementScreen({Key? key}) : super(key: key);

  @override
  State<CharacterManagementScreen> createState() => _CharacterManagementScreenState();
}

class _CharacterManagementScreenState extends State<CharacterManagementScreen> {
  final CharacterManager _characterManager = CharacterManager();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() {
      _isLoading = true;
    });

    await _characterManager.loadCharacters();

    setState(() {
      _isLoading = false;
    });
  }

  void _createNewCharacter() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CharacterCreationScreen(),
      ),
    ).then((_) {
      _loadCharacters();
    });
  }

  void _selectCharacter(Character character) {
    _characterManager.setActiveCharacter(character);
    _notificationService.addNotification('Selected character: ${character.name}');
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _deleteCharacter(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Are you sure you want to delete ${character.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _characterManager.deleteCharacter(character);
              Navigator.of(context).pop();
              setState(() {});
              _notificationService.addNotification('Character deleted: ${character.name}');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Management'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _characterManager.characters.isEmpty
              ? _buildEmptyState()
              : _buildCharacterList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewCharacter,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No characters yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Create your first character to start playing'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _createNewCharacter,
            child: const Text('Create Character'),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _characterManager.characters.length,
      itemBuilder: (context, index) {
        final character = _characterManager.characters[index];
        final isActive = _characterManager.activeCharacter?.id == character.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: isActive ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isActive
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => _selectCharacter(character),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Character avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      character.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Character info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              character.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (isActive)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${character.race.name} ${character.job.name} - Level ${character.level}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        // Stats
                        Row(
                          children: [
                            _buildStatIndicator('HP', character.hp, character.maxHp, Colors.red),
                            const SizedBox(width: 8),
                            _buildStatIndicator('MP', character.mp, character.maxMp, Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button
                  IconButton(
                    onPressed: () => _deleteCharacter(character),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatIndicator(String label, int value, int maxValue, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          const SizedBox(height: 2),
          LinearProgressIndicator(
            value: value / maxValue,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 2),
          Text('$value / $maxValue', style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
