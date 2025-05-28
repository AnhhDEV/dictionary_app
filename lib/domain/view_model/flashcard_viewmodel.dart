import 'dart:developer';

import 'package:dictionary/data/local_storage/deck_repo.dart';
import 'package:dictionary/data/local_storage/flashcard_repo.dart';
import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:dictionary/domain/model/local/deck.dart';
import 'package:dictionary/domain/model/local/flashcard_status_count.dart';
import 'package:dictionary/domain/model/local/word_flashcard.dart';
import 'package:dictionary/presentation/flash_card/flashcard_page.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';

class FlashcardViewModel extends ChangeNotifier {
  //dependencies
  final DeckRepository _deckRepo;
  final FlashCardRepository _flashCardRepo;
  final NavigationService _navigationService;
  final AudioPlayer _player;

  //textfield
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  int currentPage = 0;

  //state
  List<Deck> decks = [];
  List<WordFlashcard> flashcards = [];
  List<WordFlashcard> studiesCards = [];
  List<FlashcardStatusCount> counts = [];

  FlashcardViewModel(
    this._deckRepo,
    this._flashCardRepo,
    this._navigationService,
    this._player,
  ) {
    getAllDecks();
  }

  Future<void> getStatus(int index, List<int> flashcardKeys) async {
    var count = _flashCardRepo.countFlashcardByLearningStatus(flashcardKeys);
    counts.add(count);
    log('${count.remembered}, ${count.notLearned}, ${count.fuzzy}');
  }

  updateStatusOfFlashcard(WordFlashcard card, int quality) {
    _flashCardRepo.updateFlashcardAfterReview(card, quality);
    notifyListeners();
  }

  Future<void> createDeck() async {
    Deck deck = Deck(name.text, DateTime.now(), [], description.text, 0);
    await _deckRepo.add(deck);
    getAllDecks();
  }

  Future<void> getAllDecks() async {
    decks =  _deckRepo.getAllDecks();
    counts.clear();
    await Future.wait(
        decks.asMap().entries.map((e) {
          final idx = e.key;
          final deck = e.value;
          return getStatus(idx, deck.flashcardKeys);
        })
    );
    notifyListeners();
  }

  Future<void> getFlashcardsByKeys(List<int> keys) async {
    flashcards = _flashCardRepo.getFlashcardsByKeys(keys);
    notifyListeners();
  }

  Future<void> addFlashcardToDeck(
    String word,
    String audio,
    String phonetic,
    CacheMeaning meaning,
    String note,
    Deck deck,
  ) async {
    WordFlashcard flashcard = WordFlashcard(
      word,
      phonetic,
      meaning,
      note,
      DateTime.now(),
      audio,
      0,
      0,
      DateTime.now(),
      DateTime.now(),
      0,
      2.5,
    );
    log('flashcard: ${flashcard.word}');
    final deckKey = _deckRepo.getKeyOfDeck(deck);
    final flashcardKey = await _flashCardRepo.add(flashcard);

    if (deckKey != null) {
      _deckRepo.addFlashcardToDeck(deckKey, flashcardKey);
      _navigationService.showSnackBar('Adding Successfully');
    } else {
      _navigationService.showSnackBar('Cannot add a flashcard');
    }
  }

  Future<void> playUrlAudio(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      rethrow;
    }
  }

  onNavToFlashcard(Deck deck) {
    getFlashcardsByKeys(deck.flashcardKeys);
    getStudiesCardsToday(deck.flashcardKeys);
    if(studiesCards.isEmpty) {
      _navigationService.showSnackBar("You've already learned. Coming back later");
    } else {
      _navigationService.navigate(FlashcardPage(deck: deck));
    }
  }

  Future<void> getStudiesCardsToday(List<int> flashcardKeys) async {
    studiesCards = _flashCardRepo.getFlashcardsToStudyToday(flashcardKeys);
    notifyListeners();
  }

  onPageChange() {
    currentPage++;
    notifyListeners();
  }

  setPage(int value) {
    currentPage = value;
    notifyListeners();
  }

  resetPage() {
    currentPage = 0;
  }

  pop() {
    _navigationService.goBack();
  }
}
