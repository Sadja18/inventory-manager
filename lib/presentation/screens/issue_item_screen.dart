// issue_item_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/di/database_providers.dart';

class IssueItemScreen extends ConsumerStatefulWidget {
  const IssueItemScreen({super.key});

  @override
  ConsumerState<IssueItemScreen> createState() => _IssueItemScreenState();
}

class _IssueItemScreenState extends ConsumerState<IssueItemScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedItem;
  final issuedToController = TextEditingController();
  final quantityController = TextEditingController();
  final remarksController = TextEditingController(); // 👈 new
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryBox = ref.watch(inventoryItemBoxProvider);

    // 👇 Format date as "Jan 1, 2025" for display
    String formattedDate = DateFormat.yMMMd().format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Issue Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            // 👈 allow scrolling if keyboard covers fields
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedItem,
                  decoration: const InputDecoration(
                    labelText: 'Select Item',
                    border: OutlineInputBorder(),
                  ),
                  items: inventoryBox.values.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select an item' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: issuedToController,
                  decoration: const InputDecoration(
                    labelText: 'Issued To',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.trim().isEmpty ?? true
                      ? 'Please enter the name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Enter quantity';
                    final qty = int.tryParse(value!);
                    if (qty == null || qty <= 0) {
                      return 'Enter valid positive number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: remarksController,
                  decoration: const InputDecoration(
                    labelText: 'Remarks (e.g., Serial No, Model)',
                    border: OutlineInputBorder(),
                    hintText: 'Optional',
                  ),
                  maxLines: 3, // 👈 multi-line for paragraph
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Issuance Date: $formattedDate'),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Change'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        selectedItem != null) {
                      final newIssuance = IssuanceRecord(
                        id: const Uuid().v4(),
                        itemId: selectedItem!,
                        issuedTo: issuedToController.text.trim(),
                        issuanceDate: selectedDate,
                        quantity: int.parse(quantityController.text),
                        remarks: remarksController.text.trim().isEmpty
                            ? null
                            : remarksController.text
                                  .trim(), // 👈 save only if not empty
                      );
                      ref.read(issuanceRecordBoxProvider).add(newIssuance);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Issue Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
