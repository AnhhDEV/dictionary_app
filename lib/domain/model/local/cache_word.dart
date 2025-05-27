import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:hive/hive.dart';

part 'cache_word.g.dart';

@HiveType(typeId: 1)
class CacheWord extends HiveObject {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final String? phonetic;
  @HiveField(2)
  final String? text;
  @HiveField(3)
  final String? audio;
  @HiveField(4)
  final List<CacheMeaning> meanings;

  CacheWord(
    this.word,
    this.phonetic,
    this.text,
    this.audio,
    this.meanings,
  );
}
