import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';
import 'package:myapp/di/database_providers.dart';

class ReceiveStockScreen extends ConsumerStatefulWidget {
  const ReceiveStockScreen({super.key});

  @override
  ConsumerState<ReceiveStockScreen> createState() => _ReceiveStockScreenState();
}

class _ReceiveStockScreenState extends ConsumerState<ReceiveStockScreen> {
  final _formKey = GlobalKey<FormState>();
  InventoryItem? _selectedItem;
  final _quantityController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _receiveStock() {
    if (_formKey.currentState!.validate()) {
      final additionalQuantity = int.parse(_quantityController.text);
      final remarks = _remarksController.text;

      if (_selectedItem != null) {
        final item = _selectedItem!;

        final newReceipt = StockReceipt(
          itemId: item.key.toString(),
          quantity: additionalQuantity,
          receiptDate: DateTime.now(),
          remarks: remarks,
        );

        final stockReceiptsBox = ref.read(stockReceiptBoxProvider);
        stockReceiptsBox.add(newReceipt);

        item.receiptQty += additionalQuantity;
        item.lastReceivedDate = DateTime.now();
        item.save();

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Received $additionalQuantity of ${item.name}. New balance: ${item.balanceQty}.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryItems = ref.watch(inventoryItemBoxProvider).values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Receive Stock')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<InventoryItem>(
                initialValue: _selectedItem,
                decoration: const InputDecoration(
                  labelText: 'Select Item',
                  border: OutlineInputBorder(),
                ),
                items: inventoryItems.map((item) {
                  return DropdownMenuItem<InventoryItem>(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),
                onChanged: (item) {
                  setState(() {
                    _selectedItem = item;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an item';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Additional Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _receiveStock,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Receive Stock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
