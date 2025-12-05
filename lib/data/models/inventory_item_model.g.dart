// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryItemAdapter extends TypeAdapter<InventoryItem> {
  @override
  final int typeId = 1;

  @override
  InventoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryItem(
      id: fields[0] as String,
      name: fields[1] as String,
      categoryId: fields[2] as String,
      receiptQty: fields[3] as int,
      issuedQty: fields[4] as int,
      lastReceivedDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.receiptQty)
      ..writeByte(4)
      ..write(obj.issuedQty)
      ..writeByte(6)
      ..write(obj.lastReceivedDate)
      ..writeByte(5)
      ..write(obj.balanceQty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
