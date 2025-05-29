// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:dictionary/domain/model/local/word_flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dictionary/main.dart';

void main() {
  test('Test mọi trường hợp quality (0-3) với reviewCount (1-3)', () {
    for (int review = 1; review <= 3; review++) {
      for (int q = 0; q <= 3; q++) {
        final card = WordFlashcard(
          "test",
          "",
          CacheMeaning(antonyms: [], definitions: [], partOfSpeech: '', synonyms: []),
          "",
          DateTime.now(),
          "",
          review - 1, // Số lần học trước
          0,
          DateTime.now(),
          DateTime.now(),
          review == 1 ? 1 : (review == 2 ? 3 : 7), // Giả lập interval ban đầu cho lần học trước
          2.5,
        );

        updateReviewSchedule(card, q);

        print("reviewCount (trước): ${review - 1}, quality: $q"
            "  --> reviewCount (sau): ${card.reviewCount}, "
            "interval: ${card.interval}, "
            "nextReviewed: ${card.nextReviewed.toIso8601String()}, "
            "ease: ${card.easeFactor.toStringAsFixed(2)}");
      }
    }
  });
}

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
      card.interval = (card.interval * 2.5).round(); // hoặc dùng easeFactor nếu muốn
    }
    card.nextReviewed = now.add(Duration(days: card.interval));
  }

  card.lastReviewed = now;
}
