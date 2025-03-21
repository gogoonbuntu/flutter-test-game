import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/race.dart';
import '../models/job.dart';
import '../models/character_manager.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  CharacterCreationScreenState createState() => CharacterCreationScreenState();
}

class CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Race selectedRace = Race.races.first;
  Job selectedJob = Job.jobs.first;
  final CharacterManager _characterManager = CharacterManager();
  final NotificationService _notificationService = NotificationService();
  String selectedAvatar = 'avatar_1.png';
  
  // List of available avatars
  final List<String> avatars = [
    'avatar_1.png',
    'avatar_2.png',
    'avatar_3.png',
    'avatar_4.png',
    'avatar_5.png',
    'avatar_6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Character'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar selection
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Choose Avatar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: avatars.length,
                        itemBuilder: (context, index) {
                          final avatar = avatars[index];
                          final isSelected = avatar == selectedAvatar;
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAvatar = avatar;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade200,
                                child: Text(
                                  avatar.substring(7, 8),
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Character Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose Race',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...Race.races.map((race) => RadioListTile<Race>(
                    title: Text(race.name),
                    subtitle: Text(race.description),
                    value: race,
                    groupValue: selectedRace,
                    onChanged: (Race? value) {
                      if (value != null) {
                        setState(() {
                          selectedRace = value;
                        });
                      }
                    },
                  )),
              const SizedBox(height: 24),
              const Text(
                'Choose Class',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...Job.jobs.map((job) => RadioListTile<Job>(
                    title: Text(job.name),
                    subtitle: Text(job.description),
                    value: job,
                    groupValue: selectedJob,
                    onChanged: (Job? value) {
                      if (value != null) {
                        setState(() {
                          selectedJob = value;
                        });
                      }
                    },
                  )),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createCharacter,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Create Character',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCharacter() {
    if (_formKey.currentState!.validate()) {
      final character = Character(
        name: _nameController.text,
        race: selectedRace,
        job: selectedJob,
        avatar: selectedAvatar,
      );
      
      // Add character to the character manager
      _characterManager.addCharacter(character);
      _notificationService.addNotification('Created new character: ${character.name}');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
