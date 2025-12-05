import 'package:hive/hive.dart';

part 'stock_receipt_model.g.dart';

@HiveType(typeId: 3)
class StockReceipt extends HiveObject {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final int quantity;

  @HiveField(2)
  final DateTime receiptDate;

  @HiveField(3)
  final String? remarks;

  StockReceipt({
    required this.itemId,
    required this.quantity,
    required this.receiptDate,
    this.remarks,
  });
}
