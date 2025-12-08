// issuance_record_model.dart
import 'package:hive/hive.dart';

part 'issuance_record_model.g.dart';

@HiveType(typeId: 2)
class IssuanceRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String itemId;

  @HiveField(2)
  final String issuedTo;

  @HiveField(3)
  final DateTime issuanceDate;

  @HiveField(4)
  final int quantity;

  @HiveField(5) // 👈 new field
  final String? remarks; // e.g., "Serial: XYZ123, Model: ABC"

  IssuanceRecord({
    required this.id,
    required this.itemId,
    required this.issuedTo,
    required this.issuanceDate,
    required this.quantity,
    this.remarks, // optional
  });
}
