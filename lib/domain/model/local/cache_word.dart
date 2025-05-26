import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class CacheWord {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String word;
  @HiveField(2)
  final String? phonetic;
  @HiveField(3)
  final String? text;
  @HiveField(4)
  final String? audio;
  @HiveField(5)
  final List<CacheMeaning> meanings;

  CacheWord(
    this.id,
    this.word,
    this.phonetic,
    this.text,
    this.audio,
    this.meanings,
  );
}
