// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issuance_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IssuanceRecordAdapter extends TypeAdapter<IssuanceRecord> {
  @override
  final int typeId = 2;

  @override
  IssuanceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IssuanceRecord(
      id: fields[0] as String,
      itemId: fields[1] as String,
      issuedTo: fields[2] as String,
      issuanceDate: fields[3] as DateTime,
      quantity: fields[4] as int,
      remarks: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IssuanceRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.issuedTo)
      ..writeByte(3)
      ..write(obj.issuanceDate)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssuanceRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
