import 'package:hive/hive.dart';

part 'deck.g.dart';

@HiveType(typeId: 4)
class Deck extends HiveObject {

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime lastLearned;
  @HiveField(3)
  final int learningCount;
  @HiveField(4)
  final List<int> flashcardKeys;

  Deck(this.name, this.lastLearned, this.flashcardKeys, this.description, this.learningCount);

}
