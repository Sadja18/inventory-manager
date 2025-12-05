import 'package:flutter/material.dart';

class WelcomeGuide extends StatelessWidget {
  const WelcomeGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_outlined,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Your Inventory!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Follow these steps to get started:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildStep(
                context,
                icon: Icons.category,
                title: '1. Create Categories',
                subtitle: 'Group your items into categories like "Office Supplies" or "Electronics".',
              ),
              const SizedBox(height: 24),
              _buildStep(
                context,
                icon: Icons.add_shopping_cart,
                title: '2. Add Items',
                subtitle: 'Add individual items to your inventory, assigning them to a category.',
              ),
              const SizedBox(height: 24),
              _buildStep(
                context,
                icon: Icons.archive,
                title: '3. Receive Stock',
                subtitle: 'Log new stock as it arrives to keep your inventory up-to-date.',
              ),
              const SizedBox(height: 24),
              _buildStep(
                context,
                icon: Icons.unarchive,
                title: '4. Issue Stock',
                subtitle: 'Track items that you issue to others to keep your balances accurate.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
