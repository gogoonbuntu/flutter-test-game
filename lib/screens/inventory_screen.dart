import 'package:flutter/material.dart';
import '../models/item.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example items
    final List<Item> items = [
      const Item(
        name: 'Iron Sword',
        type: ItemType.weapon,
        value: 100,
        description: 'A basic sword',
        stats: {'ATK': 5},
      ),
      const Item(
        name: 'Leather Armor',
        type: ItemType.armor,
        value: 80,
        description: 'Basic protective gear',
        stats: {'DEF': 3},
      ),
      const Item(
        name: 'Health Potion',
        type: ItemType.potion,
        value: 50,
        description: 'Restores 50 HP',
        stats: {'HP': 50},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'Gold: ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '500',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      _getItemIcon(item.type),
                      color: _getItemColor(item.type),
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.description),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${item.stats.entries.first.key}: +${item.stats.entries.first.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Value: ${item.value}G'),
                      ],
                    ),
                    onTap: () => _showItemDetails(context, item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getItemIcon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Icons.gavel;
      case ItemType.armor:
        return Icons.shield;
      case ItemType.potion:
        return Icons.local_drink;
    }
  }

  Color _getItemColor(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Colors.red;
      case ItemType.armor:
        return Colors.blue;
      case ItemType.potion:
        return Colors.green;
    }
  }

  void _showItemDetails(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 8),
            Text('Type: ${item.type.toString().split('.').last}'),
            Text('Value: ${item.value} Gold'),
            const SizedBox(height: 8),
            const Text('Stats:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...item.stats.entries.map(
              (stat) => Text('${stat.key}: +${stat.value}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement use/equip functionality
              Navigator.pop(context);
            },
            child: Text(
              item.type == ItemType.potion ? 'Use' : 'Equip',
            ),
          ),
        ],
      ),
    );
  }
}
