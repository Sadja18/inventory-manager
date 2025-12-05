import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/di/database_providers.dart';
import 'package:myapp/navigation_routes.dart';
import 'package:myapp/presentation/widgets/welcome_guide.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final inventoryBox = ref.watch(inventoryItemBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Inventory...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: inventoryBox.listenable(),
              builder: (context, Box<InventoryItem> box, _) {
                final filteredItems = box.values
                    .where((item) =>
                        item.name.toLowerCase().contains(searchQuery))
                    .toList();

                if (box.isEmpty && searchQuery.isEmpty) {
                  return const WelcomeGuide();
                }

                if (filteredItems.isEmpty) {
                  return const Center(
                    child: Text(
                        'No inventory items match your search. Try a different query!'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Card(
                      elevation: 4, // Add some shadow
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoColumn(
                                    'Receipt', item.receiptQty.toString()),
                                _buildInfoColumn(
                                    'Issued', item.issuedQty.toString()),
                                _buildInfoColumn(
                                    'Balance', item.balanceQty.toString()),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.lastReceivedDate != null
                                      ? 'Last Received: ${DateFormat.yMMMd().format(item.lastReceivedDate!)}'
                                      : 'Last Received: N/A',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.history,
                                          color: Colors.blueAccent),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.itemHistory,
                                          arguments: item,
                                        );
                                      },
                                      tooltip: 'View History',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
                                      onPressed: () => box.delete(item.key),
                                      tooltip: 'Delete Item',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Theme.of(context).primaryColor,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Add New Item',
            onTap: () => Navigator.pushNamed(context, AppRoutes.addItem),
          ),
          SpeedDialChild(
            child: const Icon(Icons.archive),
            label: 'Receive Stock',
            onTap: () => Navigator.pushNamed(context, AppRoutes.receiveStock),
          ),
          SpeedDialChild(
            child: const Icon(Icons.outbox),
            label: 'Issue Item',
            onTap: () => Navigator.pushNamed(context, AppRoutes.issueItem),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
