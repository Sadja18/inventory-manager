import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';
import 'package:myapp/data/report_generator.dart';

class ItemHistoryScreen extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String financialYear;

  const ItemHistoryScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.financialYear,
  });

  @override
  State<ItemHistoryScreen> createState() => _ItemHistoryScreenState();
}

class _ItemHistoryScreenState extends State<ItemHistoryScreen> {
  final ReportGenerator _reportGenerator = ReportGenerator();
  Future<List<StockReceipt>>? _stockHistory;
  Future<List<IssuanceRecord>>? _issuanceHistory;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  void _loadHistoryData() {
    setState(() {
      _stockHistory = _reportGenerator.getItemStockHistory(
          widget.itemId, widget.financialYear);
      _issuanceHistory = _reportGenerator.getItemIssuanceHistory(
          widget.itemId, widget.financialYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.itemName} - ${widget.financialYear}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Stock History'),
              Tab(text: 'Issuance History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStockHistoryTab(),
            _buildIssuanceHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildStockHistoryTab() {
    return FutureBuilder<List<StockReceipt>>(
      future: _stockHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No stock history found.'));
        }
        final history = snapshot.data!;
        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final receipt = history[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text('Received ${receipt.quantity} units'),
                subtitle: Text(
                    'on ${DateFormat.yMMMd().format(receipt.receiptDate)}'),
                trailing: Text(receipt.remarks ?? ''),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIssuanceHistoryTab() {
    return FutureBuilder<List<IssuanceRecord>>(
      future: _issuanceHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No issuance history found.'));
        }
        final history = snapshot.data!;
        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final issuance = history[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text('Issued ${issuance.quantity} units'),
                subtitle: Text(
                    'to ${issuance.issuedTo} on ${DateFormat.yMMMd().format(issuance.issuanceDate)}'),
              ),
            );
          },
        );
      },
    );
  }
}
