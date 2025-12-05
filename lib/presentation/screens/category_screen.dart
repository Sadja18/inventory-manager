import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:myapp/data/models/category_model.dart';
import 'package:myapp/di/database_providers.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newCategory = Category(
                    id: const Uuid().v4(),
                    name: nameController.text,
                  );
                  ref.read(categoryBoxProvider).add(newCategory);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryBox = ref.watch(categoryBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ValueListenableBuilder(
        valueListenable: categoryBox.listenable(),
        builder: (context, Box<Category> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('No categories yet. Add one to get started!'),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final category = box.getAt(index) as Category;
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => box.deleteAt(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
