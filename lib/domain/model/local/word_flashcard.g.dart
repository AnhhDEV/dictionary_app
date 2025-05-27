// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_flashcard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordFlashcardAdapter extends TypeAdapter<WordFlashcard> {
  @override
  final int typeId = 3;

  @override
  WordFlashcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordFlashcard(
      fields[0] as String,
      fields[1] as String,
      fields[3] as CacheMeaning,
      fields[4] as String,
      fields[5] as DateTime,
      fields[2] as String,
      fields[6] as int,
      fields[7] as int,
      fields[8] as DateTime,
      fields[9] as DateTime,
      fields[10] as int,
      fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WordFlashcard obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.phonetic)
      ..writeByte(2)
      ..write(obj.audio)
      ..writeByte(3)
      ..write(obj.meaning)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.reviewCount)
      ..writeByte(7)
      ..write(obj.rememberLevel)
      ..writeByte(8)
      ..write(obj.lastReviewed)
      ..writeByte(9)
      ..write(obj.nextReviewed)
      ..writeByte(10)
      ..write(obj.interval)
      ..writeByte(11)
      ..write(obj.easeFactor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordFlashcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
