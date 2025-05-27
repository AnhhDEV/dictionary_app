// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_meaning.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheMeaningAdapter extends TypeAdapter<CacheMeaning> {
  @override
  final int typeId = 0;

  @override
  CacheMeaning read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheMeaning(
      partOfSpeech: fields[0] as String,
      definitions: (fields[1] as List).cast<String>(),
      synonyms: (fields[2] as List).cast<String>(),
      antonyms: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheMeaning obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.partOfSpeech)
      ..writeByte(1)
      ..write(obj.definitions)
      ..writeByte(2)
      ..write(obj.synonyms)
      ..writeByte(3)
      ..write(obj.antonyms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheMeaningAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
