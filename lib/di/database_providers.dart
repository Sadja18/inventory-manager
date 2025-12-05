import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:myapp/data/models/category_model.dart';
import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';

final categoryBoxProvider = Provider<Box<Category>>((ref) {
  return Hive.box<Category>('categories');
});

final inventoryItemBoxProvider = Provider<Box<InventoryItem>>((ref) {
  return Hive.box<InventoryItem>('inventory_items');
});

final issuanceRecordBoxProvider = Provider<Box<IssuanceRecord>>((ref) {
  return Hive.box<IssuanceRecord>('issuance_records');
});

final stockReceiptBoxProvider = Provider<Box<StockReceipt>>((ref) {
  return Hive.box<StockReceipt>('stock_receipts');
});
