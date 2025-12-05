import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';
import 'package:myapp/di/database_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late String _selectedFinancialYear;
  List<String> _financialYears = [];

  @override
  void initState() {
    super.initState();
    _financialYears = _getFinancialYears();
    _selectedFinancialYear = _getCurrentFinancialYear();
  }

  String _getCurrentFinancialYear() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    return month >= 4 ? '$year-${year + 1}' : '${year - 1}-$year';
  }

  List<String> _getFinancialYears() {
    final currentYear = DateTime.now().year;
    return List.generate(5, (index) {
      final year = currentYear - index;
      return '${year - 1}-$year';
    });
  }

  @override
  Widget build(BuildContext context) {
    final issuanceRecords = ref
        .watch(issuanceRecordBoxProvider)
        .values
        .toList();
    final stockReceipts = ref.watch(stockReceiptBoxProvider).values.toList();
    final inventoryItems = ref.watch(inventoryItemBoxProvider).values.toList();

    final fyDates = _getFinancialYearDates(_selectedFinancialYear);

    final receiptsInFy = stockReceipts
        .where(
          (r) =>
              r.receiptDate.isAfter(fyDates.start) &&
              r.receiptDate.isBefore(fyDates.end),
        )
        .toList();

    final issuesInFy = issuanceRecords
        .where(
          (i) =>
              i.issuanceDate.isAfter(fyDates.start) &&
              i.issuanceDate.isBefore(fyDates.end),
        )
        .toList();

    final totalReceipts = receiptsInFy.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
    final totalIssues = issuesInFy.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Year Reports')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedFinancialYear,
              decoration: const InputDecoration(
                labelText: 'Select Financial Year',
                border: OutlineInputBorder(),
              ),
              items: _financialYears.map((fy) {
                return DropdownMenuItem<String>(value: fy, child: Text(fy));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedFinancialYear = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard(
                  'Total Received',
                  totalReceipts.toString(),
                  Colors.green,
                ),
                _buildSummaryCard(
                  'Total Issued',
                  totalIssues.toString(),
                  Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Stock Receipts'),
                      Tab(text: 'Issuance Records'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildReceiptsList(receiptsInFy, inventoryItems),
                        _buildIssuesList(issuesInFy, inventoryItems),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ({DateTime start, DateTime end}) _getFinancialYearDates(String fy) {
    final years = fy.split('-');
    final startYear = int.parse(years[0]);
    final endYear = int.parse(years[1]);
    return (
      start: DateTime(startYear, 4, 1),
      end: DateTime(endYear, 3, 31, 23, 59, 59),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptsList(
    List<StockReceipt> receipts,
    List<InventoryItem> items,
  ) {
    if (receipts.isEmpty) {
      return const Center(child: Text('No stock receipts in this period.'));
    }

    return ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        final receipt = receipts[index];
        final item = items.firstWhere(
          (i) => i.id == receipt.itemId,
          orElse: () => InventoryItem(
            id: 'unknown-item',
            name: 'Unknown',
            categoryId: '',
          ),
        );
        return ListTile(
          title: Text('${item.name} - Qty: ${receipt.quantity}'),
          subtitle: Text(
            'Date: ${DateFormat.yMMMd().format(receipt.receiptDate)} - ${receipt.remarks ?? ''}',
          ),
        );
      },
    );
  }

  Widget _buildIssuesList(
    List<IssuanceRecord> issues,
    List<InventoryItem> items,
  ) {
    if (issues.isEmpty) {
      return const Center(child: Text('No issuance records in this period.'));
    }

    return ListView.builder(
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        final item = items.firstWhere(
          (i) => i.id == issue.itemId,
          orElse: () => InventoryItem(
            id: 'unknown-item',
            name: 'Unknown',
            categoryId: '',
          ),
        );

        return ListTile(
          title: Text('${item.name} - Qty: ${issue.quantity}'),
          subtitle: Text(
            'Date: ${DateFormat.yMMMd().format(issue.issuanceDate)} - Issued to: ${issue.issuedTo}',
          ),
        );
      },
    );
  }
}
