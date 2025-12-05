import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/di/database_providers.dart';

class ItemHistoryScreen extends ConsumerWidget {
  final InventoryItem item;

  const ItemHistoryScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuanceRecordBox = ref.watch(issuanceRecordBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('History for ${item.name}'),
      ),
      body: ValueListenableBuilder(
        valueListenable: issuanceRecordBox.listenable(),
        builder: (context, Box<IssuanceRecord> box, _) {
          final history = box.values
              .where((record) => record.itemId == item.id)
              .toList();

          if (history.isEmpty) {
            return const Center(
              child: Text('No issuance history for this item.'),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final record = history[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Issued to: ${record.issuedTo}'),
                  subtitle: Text(
                    'Date: ${DateFormat.yMMMd().format(record.issuanceDate)}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
