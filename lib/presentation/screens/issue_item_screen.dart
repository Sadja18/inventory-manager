import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
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
                validator: (value) {
                  if (value == null) {
                    return 'Please select an item';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: issuedToController,
                decoration: const InputDecoration(
                  labelText: 'Issued To',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the person';
                  }
                  return null;
                },
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Issuance Date: ${selectedDate.toLocal()} '.split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final newIssuance = IssuanceRecord(
                      id: const Uuid().v4(),
                      itemId: selectedItem!,
                      issuedTo: issuedToController.text,
                      issuanceDate: selectedDate,
                      quantity: int.parse(quantityController.text),
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
    );
  }
}
