import 'package:hive/hive.dart';

part 'inventory_item_model.g.dart';

@HiveType(typeId: 1)
class InventoryItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  int receiptQty;

  @HiveField(4)
  int issuedQty;

  @HiveField(5)
  int get balanceQty => receiptQty - issuedQty;

  @HiveField(6)
  DateTime? lastReceivedDate;

  InventoryItem({
    required this.id,
    required this.name,
    required this.categoryId,
    this.receiptQty = 0,
    this.issuedQty = 0,
    this.lastReceivedDate,
  });
}
