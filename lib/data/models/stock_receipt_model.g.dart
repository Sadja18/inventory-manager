// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_receipt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockReceiptAdapter extends TypeAdapter<StockReceipt> {
  @override
  final int typeId = 3;

  @override
  StockReceipt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockReceipt(
      itemId: fields[0] as String,
      quantity: fields[1] as int,
      receiptDate: fields[2] as DateTime,
      remarks: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StockReceipt obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.receiptDate)
      ..writeByte(3)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockReceiptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
