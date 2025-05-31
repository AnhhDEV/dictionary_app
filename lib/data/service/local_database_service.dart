import 'package:dictionary/data/local_storage/deck_repo.dart';
import 'package:dictionary/data/local_storage/flashcard_repo.dart';
import 'package:dictionary/domain/model/local/deck.dart';
import 'package:dictionary/domain/model/local/word_flashcard.dart';
import 'package:hive_flutter/adapters.dart';

import '../../domain/model/local/cache_meaning.dart';
import '../../domain/model/local/cache_word.dart';
import '../../domain/model/local/searched_word.dart';
import '../local_storage/cache_word_repo.dart';
import '../local_storage/searched_word_repo.dart';

class LocalDatabaseService {
  static Future<(CacheWordRepository, SearchedWordRepository, FlashCardRepository, DeckRepository)> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CacheMeaningAdapter());
    Hive.registerAdapter(CacheWordAdapter());
    Hive.registerAdapter(SearchedWordAdapter());
    Hive.registerAdapter(WordFlashcardAdapter());
    Hive.registerAdapter(DeckAdapter());

    final cacheBox = await Hive.openBox<CacheWord>('cache_words');
    final searchedBox = await Hive.openBox<SearchedWord>('searched_words');
    final flashcardBox = await Hive.openBox<WordFlashcard>("flashcard");
    final deckBox = await Hive.openBox<Deck>("deck");

    return (
    CacheWordRepository(cacheBox),
    SearchedWordRepository(searchedBox),
    FlashCardRepository(flashcardBox, deckBox),
    DeckRepository(deckBox)
    );
  }
}