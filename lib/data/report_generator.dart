import 'package:hive/hive.dart';
import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';

class ReportGenerator {
  Future<List<Map<String, dynamic>>> getReportData(String financialYear) async {
    final inventoryBox = await Hive.openBox<InventoryItem>('inventory_items');
    final issuanceBox = await Hive.openBox<IssuanceRecord>('issuance_records');
    final stockReceiptBox = await Hive.openBox<StockReceipt>('stock_receipts');

    final fyDates = _getFyDates(financialYear);
    final startDate = fyDates[0];
    final endDate = fyDates[1];

    List<Map<String, dynamic>> reportData = [];
    int serialNumber = 1;

    for (var item in inventoryBox.values) {
      int openingBalanceReceipts = 0;
      for (var receipt in stockReceiptBox.values.where((r) => r.itemId == item.id && r.receiptDate.isBefore(startDate))) {
        openingBalanceReceipts += receipt.quantity;
      }

      int openingBalanceIssues = 0;
      for (var issuance in issuanceBox.values.where((i) => i.itemId == item.id && i.issuanceDate.isBefore(startDate))) {
        openingBalanceIssues += issuance.quantity;
      }

      int openingBalance = openingBalanceReceipts - openingBalanceIssues;

      int receiptsInFy = 0;
      for (var receipt in stockReceiptBox.values.where((r) => r.itemId == item.id && !r.receiptDate.isBefore(startDate) && r.receiptDate.isBefore(endDate))) {
        receiptsInFy += receipt.quantity;
      }
      
      int issuedInFy = 0;
      for (var issuance in issuanceBox.values.where((i) => i.itemId == item.id && !i.issuanceDate.isBefore(startDate) && i.issuanceDate.isBefore(endDate))) {
        issuedInFy += issuance.quantity;
      }

      if (openingBalance != 0 || receiptsInFy != 0 || issuedInFy != 0) {
        int reportReceiptQty = openingBalance + receiptsInFy;
        int reportBalanceQty = reportReceiptQty - issuedInFy;
        
        reportData.add({
          's_no': serialNumber++,
          'item_name': item.name,
          'item_id': item.id,
          'receipt_qty': reportReceiptQty,
          'issued_qty': issuedInFy,
          'balance_qty': reportBalanceQty,
        });
      }
    }

    return reportData;
  }

  Future<List<StockReceipt>> getItemStockHistory(String itemId, String financialYear) async {
    final stockReceiptBox = await Hive.openBox<StockReceipt>('stock_receipts');
    final fyDates = _getFyDates(financialYear);
    final startDate = fyDates[0];
    final endDate = fyDates[1];

    return stockReceiptBox.values
        .where((receipt) =>
            receipt.itemId == itemId &&
            !receipt.receiptDate.isBefore(startDate) &&
            receipt.receiptDate.isBefore(endDate))
        .toList();
  }

  Future<List<IssuanceRecord>> getItemIssuanceHistory(String itemId, String financialYear) async {
    final issuanceBox = await Hive.openBox<IssuanceRecord>('issuance_records');
    final fyDates = _getFyDates(financialYear);
    final startDate = fyDates[0];
    final endDate = fyDates[1];

    return issuanceBox.values
        .where((issuance) =>
            issuance.itemId == itemId &&
            !issuance.issuanceDate.isBefore(startDate) &&
            issuance.issuanceDate.isBefore(endDate))
        .toList();
  }

  List<DateTime> _getFyDates(String financialYear) {
    final yearParts = financialYear.substring(3).split('-');
    final startYear = int.parse(yearParts[0]);
    
    final startDate = DateTime(startYear, 4, 1);
    final endDate = DateTime(startYear + 1, 4, 1);

    return [startDate, endDate];
  }
}
