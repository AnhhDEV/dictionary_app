import 'package:dictionary/domain/model/local/word_flashcard.dart';

class FlashcardData {
  final List<WordFlashcard> rememberedFlashcards;
  final List<WordFlashcard> unrememberedFlashcards;

  FlashcardData(this.rememberedFlashcards, this.unrememberedFlashcards);
}

extension FlashcardExtension on FlashcardData {
  int getFlashcardLength() {
    return rememberedFlashcards.length + unrememberedFlashcards.length;
  }

  List<WordFlashcard> getAllCards() {
    return rememberedFlashcards + unrememberedFlashcards;
  }

  List<WordFlashcard> getRememberedCards() {
    return rememberedFlashcards;
  }

  List<WordFlashcard> getUnrememberedCards() {
    return unrememberedFlashcards;
  }
}
