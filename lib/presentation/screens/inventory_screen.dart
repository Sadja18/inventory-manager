// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/issuance_record_model.dart';

import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';
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

  String _getCurrentFinancialYear() {
    final now = DateTime.now();
    int year = now.year;
    if (now.month < 4) {
      year--; // If before April, it's part of the previous financial year
    }
    return 'FY $year-${(year + 1).toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final inventoryBox = ref.watch(inventoryItemBoxProvider);
    final stockReceiptBox = ref.watch(stockReceiptBoxProvider);
    final issuanceBox = ref.watch(issuanceRecordBoxProvider);

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
                    final receipts = stockReceiptBox.values.where((r) => r.itemId == item.id).toList();
                    final issues = issuanceBox.values.where((i) => i.itemId == item.id).toList();

                    final totalReceipts = receipts.fold(0, (sum, r) => sum + r.quantity);
                    final totalIssues = issues.fold(0, (sum, i) => sum + i.quantity);
                    final balance = totalReceipts - totalIssues;

                    DateTime? lastReceivedDate;
                    if (receipts.isNotEmpty) {
                      receipts.sort((a, b) => b.receiptDate.compareTo(a.receiptDate));
                      lastReceivedDate = receipts.first.receiptDate;
                    }

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
                                _buildInfoColumn('Receipt', totalReceipts.toString()),
                                _buildInfoColumn('Issued', totalIssues.toString()),
                                _buildInfoColumn('Balance', balance.toString()),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lastReceivedDate != null
                                      ? 'Last Received: ${DateFormat.yMMMd().format(lastReceivedDate)}'
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
                                          arguments: {
                                            'itemId': item.id,
                                            'itemName': item.name,
                                            'financialYear':
                                                _getCurrentFinancialYear(),
                                          },
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
