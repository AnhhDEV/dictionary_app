// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchedWordAdapter extends TypeAdapter<SearchedWord> {
  @override
  final int typeId = 2;

  @override
  SearchedWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchedWord(
      fields[0] as int,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SearchedWord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.keyWord)
      ..writeByte(1)
      ..write(obj.searchTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchedWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
