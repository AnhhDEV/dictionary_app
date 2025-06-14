// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheWordAdapter extends TypeAdapter<CacheWord> {
  @override
  final int typeId = 1;

  @override
  CacheWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheWord(
      fields[0] as String,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
      (fields[4] as List).cast<CacheMeaning>(),
      fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CacheWord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.phonetic)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.audio)
      ..writeByte(4)
      ..write(obj.meanings)
      ..writeByte(5)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
