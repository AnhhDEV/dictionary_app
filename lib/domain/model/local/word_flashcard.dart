import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:hive/hive.dart';

part 'word_flashcard.g.dart';

@HiveType(typeId: 3)
class WordFlashcard extends HiveObject {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final String phonetic;
  @HiveField(2)
  final String audio;
  @HiveField(3)
  final CacheMeaning meaning;
  @HiveField(4)
  final String note;
  @HiveField(5)
  final DateTime createdAt;

  //progress
  @HiveField(6)
  int reviewCount;
  @HiveField(7)
  int rememberLevel;
  @HiveField(8)
  DateTime lastReviewed;
  @HiveField(9)
  DateTime nextReviewed;
  @HiveField(10)
  int interval;
  @HiveField(11)
  double easeFactor;

  WordFlashcard(
    this.word,
    this.phonetic,
    this.meaning,
    this.note,
    this.createdAt,
    this.audio,
    this.reviewCount,
    this.rememberLevel,
    this.lastReviewed,
    this.nextReviewed,
    this.interval,
    this.easeFactor,
  );


}
