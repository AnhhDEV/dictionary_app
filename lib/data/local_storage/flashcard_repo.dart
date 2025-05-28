import 'package:dictionary/domain/model/local/word_flashcard.dart';
import 'package:hive/hive.dart';

import '../../domain/model/local/flashcard_status_count.dart';

class FlashCardRepository {

  final Box<WordFlashcard> _box;

  FlashCardRepository(this._box);

  Future<int> add(WordFlashcard word) async {
    return await _box.add(word);
  }

  WordFlashcard? getByKey(String key) {
    return _box.get(key);
  }

  List<WordFlashcard> getFlashcardsByKeys(List<int> keys) {
    return keys.map((key) => _box.get(key)).whereType<WordFlashcard>().toList();
  }

  FlashcardStatusCount countFlashcardByLearningStatus(List<int> flashcardKeys) {
    int notLearned = 0;
    int fuzzy = 0;
    int remembered = 0;

    for (var key in flashcardKeys) {
      final card = _box.get(key);
      if (card == null) continue;

      if (card.reviewCount == 0) {
        notLearned++;
      } else if (card.rememberLevel == 2 && card.interval >= 7) {
        remembered++;
      } else {
        fuzzy++;
      }
    }

    return FlashcardStatusCount(
      notLearned: notLearned,
      fuzzy: fuzzy,
      remembered: remembered,
    );
  }

  List<WordFlashcard> getFlashcardsToStudyToday(List<int> flashcardKeys) {
    final now = DateTime.now();
    return flashcardKeys
        .map((key) => _box.get(key))
        .whereType<WordFlashcard>()
        .where((card) =>
    card.reviewCount == 0 || card.nextReviewed.isBefore(now) || card.nextReviewed.isAtSameMomentAs(now))
        .toList();
  }

  //update
  void updateFlashcardAfterReview(WordFlashcard card, int quality) {
    final now = DateTime.now();

    if(quality < 2) {
      card.interval = 1;
      card.easeFactor = (card.easeFactor - 0.2).clamp(1.3, double.infinity);
    } else {
      if(card.reviewCount == 0) {
        card.interval = 1;
      } else if(card.reviewCount == 1) {
        card.interval = 3;
      } else {
        card.interval = (card.interval * card.easeFactor).round();
      }

      card.easeFactor += (0.1 - (3 - quality) * (0.08 + (3 - quality) * 0.02));
      card.easeFactor = card.easeFactor.clamp(1.3, double.infinity);
    }

    card.reviewCount += 1;
    card.lastReviewed = now;
    card.nextReviewed = now.add(Duration(days: card.interval));

    if(quality == 0) {
      card.rememberLevel = 0;
    } else if(quality == 1) {
      card.rememberLevel = 1;
    } else {
      card.rememberLevel = 2;
    }
    card.save();
  }

}