import 'dart:math';

import 'package:dictionary/domain/model/local/deck.dart';
import 'package:dictionary/domain/model/local/flashcard_data.dart';
import 'package:dictionary/domain/model/local/word_flashcard.dart';
import 'package:hive/hive.dart';

import '../../domain/model/local/flashcard_status_count.dart';

class FlashCardRepository {
  final Box<WordFlashcard> _box;
  final Box<Deck> _deck;

  FlashCardRepository(this._box, this._deck);

  Future<int> add(WordFlashcard word) async {
    return await _box.add(word);
  }

  removeFlashcard(int key) {
    _box.delete(key);
  }

  WordFlashcard? getByKey(String key) {
    return _box.get(key);
  }

  FlashcardData getAllFlashcards(List<int> deckKeys) {
    List<WordFlashcard> remembered = [];
    List<WordFlashcard> unremembered = [];

    for (final key in deckKeys) {
      final deck = _deck.get(key);
      if (deck == null) continue;

      final flashcards = getFlashcardsByKeys(deck.flashcardKeys);
      for (final card in flashcards) {
        if (card.reviewCount == 0) {
          unremembered.add(card);
        } else {
          remembered.add(card);
        }
      }
    }

    return FlashcardData(remembered, unremembered);
  }

  bool isRemembered(WordFlashcard card) {
    return card.reviewCount > 0;
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
        .where(
          (card) =>
              card.reviewCount == 0 ||
              card.nextReviewed.isBefore(now) ||
              card.nextReviewed.isAtSameMomentAs(now),
        )
        .toList();
  }

  //update
  void updateReviewSchedule(WordFlashcard card, int quality) {
    final now = DateTime.now();

    if (quality == 0) {
      // Quên hoàn toàn, lặp lại sau 10 phút
      card.reviewCount = 0;
      card.interval = 0;
      card.nextReviewed = now.add(Duration(minutes: 10));
    } else if (quality == 1) {
      // Gợi nhớ mơ hồ, lặp lại sau 30 phút
      card.reviewCount = 0;
      card.interval = 0;
      card.nextReviewed = now.add(Duration(minutes: 30));
    } else if (quality == 2) {
      // Nhớ tạm được
      if (card.reviewCount == 0) {
        // Lần đầu nhớ tạm, lặp lại sau 1 tiếng
        card.reviewCount = 1;
        card.interval = 0;
        card.nextReviewed = now.add(Duration(hours: 1));
      } else {
        // Các lần sau, vẫn để interval 1 ngày để học chắc lại
        card.reviewCount = 1;
        card.interval = 1;
        card.nextReviewed = now.add(Duration(days: 1));
      }
    } else if (quality == 3) {
      // Nhớ rõ, tăng dần số ngày
      card.reviewCount += 1;
      if (card.reviewCount == 1) {
        card.interval = 1;
      } else if (card.reviewCount == 2) {
        card.interval = 3;
      } else if (card.reviewCount == 3) {
        card.interval = 7;
      } else {
        card.interval =
            (card.interval * 2.5).round();
      }
      card.nextReviewed = now.add(Duration(days: card.interval));
    }
    if (card.reviewCount == 0) {
      card.rememberLevel = 0;
    } else if (card.interval >= 7) {
      card.rememberLevel = 2;
    } else {
      card.rememberLevel = 1;
    }
    card.lastReviewed = now;
  }
}
