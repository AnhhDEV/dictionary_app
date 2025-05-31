import 'dart:developer';

import 'package:dictionary/data/local_storage/deck_repo.dart';
import 'package:dictionary/data/local_storage/flashcard_repo.dart';
import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:dictionary/domain/model/local/deck.dart';
import 'package:dictionary/domain/model/local/flashcard_data.dart';
import 'package:dictionary/domain/model/local/flashcard_status_count.dart';
import 'package:dictionary/domain/model/local/word_flashcard.dart';
import 'package:dictionary/presentation/flash_card/add_card_page.dart';
import 'package:dictionary/presentation/flash_card/flashcard_page.dart';
import 'package:dictionary/presentation/flash_card/statistic_page.dart';
import 'package:file_picker/file_picker.dart';
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
  TextEditingController note = TextEditingController();

  //state
  int currentPage = 0;
  List<Deck> decks = [];
  List<WordFlashcard> flashcards = [];
  List<WordFlashcard> studiesCards = [];
  List<FlashcardStatusCount> counts = [];
  CacheMeaning? selectedMeaning;
  FlashcardData? flashcardData;

  @override
  void dispose() {
    name.dispose();
    note.dispose();
    description.dispose();
    _player.dispose();
    super.dispose();
  }

  FlashcardViewModel(this._deckRepo,
      this._flashCardRepo,
      this._navigationService,
      this._player,) {
    getAllDecks();
  }

  List<WordFlashcard> filterList(String value, List<WordFlashcard> list) {
    return list.where((WordFlashcard card) =>
        card.word.contains(value.trim().toLowerCase())
    ).toList();
  }

  void getAllCards() {
    List<int> deckKeys =
    decks
        .map((Deck deck) => _deckRepo.getKeyOfDeck(deck))
        .nonNulls
        .toList();
    if (deckKeys.isNotEmpty) {
      flashcardData = _flashCardRepo.getAllFlashcards(deckKeys);
      _navigationService.navigate(StatisticPage());
    } else {
      _navigationService.showSnackBar("You've currently not learned any decks");
    }
  }

  Future<void> pickAudio(Function(String) onClicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'ogg'],
    );
    if (result != null && result.files.isNotEmpty) {
      String? path = result.files.single.path;
      if (path != null) {
        // audioPath = path;
        onClicked(path);
        _navigationService.showSnackBar('Add new audio file successfully');
      } else {
        _navigationService.showSnackBar('Oops');
      }
    }
    notifyListeners();
  }

  Future<void> createFlashcard(Deck deck,
      String word,
      String pos,
      String note,
      String audio,) async {
    WordFlashcard flashcard = WordFlashcard(
      word,
      '',
      CacheMeaning(
        antonyms: [],
        definitions: [],
        partOfSpeech: pos,
        synonyms: [],
      ),
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
    int key = await _flashCardRepo.add(flashcard);
    int? deckKey = _deckRepo.getKeyOfDeck(deck);
    if (deckKey == null) {
      _navigationService.showSnackBar('Oops');
    } else {
      await _deckRepo.addFlashcardToDeck(deckKey, key);
      _navigationService.goBack();
      _navigationService.showSnackBar('Create successfully');
    }
  }

  Future<void> removeDeck(Deck deck) async {
    final keys = deck.flashcardKeys;
    await _deckRepo.removeDeck(deck);
    for (var key in keys) {
      _flashCardRepo.removeFlashcard(key);
    }
    getAllDecks();
    notifyListeners();
  }

  Future<void> getStatus(int index, List<int> flashcardKeys) async {
    var count = _flashCardRepo.countFlashcardByLearningStatus(flashcardKeys);
    counts.add(count);
    // log('${count.remembered}, ${count.notLearned}, ${count.fuzzy}');
  }

  updateStatusOfFlashcard(WordFlashcard card, int quality) {
    _flashCardRepo.updateReviewSchedule(card, quality);
    notifyListeners();
  }

  Future<void> createDeck() async {
    Deck deck = Deck(name.text, DateTime.now(), [], description.text, 0);
    await _deckRepo.add(deck);
    getAllDecks();
  }

  Future<void> getAllDecks() async {
    decks = _deckRepo.getAllDecks();
    counts.clear();
    await Future.wait(
      decks
          .asMap()
          .entries
          .map((e) {
        final idx = e.key;
        final deck = e.value;
        return getStatus(idx, deck.flashcardKeys);
      }),
    );
    notifyListeners();
  }

  Future<void> getFlashcardsByKeys(List<int> keys) async {
    flashcards = _flashCardRepo.getFlashcardsByKeys(keys);
    notifyListeners();
  }

  Future<void> addFlashcardToDeck(String word,
      String audio,
      String phonetic,
      Deck deck,) async {
    if (selectedMeaning == null) {
      _navigationService.showSnackBar('Adding unsuccessfully');
      return;
    }
    WordFlashcard flashcard = WordFlashcard(
      word,
      phonetic,
      selectedMeaning!,
      note.text,
      DateTime.now(),
      audio,
      0,
      0,
      DateTime.now(),
      DateTime.now(),
      0,
      2.5,
    );
    final deckKey = _deckRepo.getKeyOfDeck(deck);
    final flashcardKey = await _flashCardRepo.add(flashcard);

    if (deckKey != null) {
      _deckRepo.addFlashcardToDeck(deckKey, flashcardKey);
      pop();
      _navigationService.showSnackBar('Adding Successfully');
    } else {
      _navigationService.showSnackBar('Cannot add a flashcard');
    }
  }

  Future<void> playAudio(String pathOrUrl) async {
    try {
      if (_player.playing) {
        await _player.stop();
        return;
      }
      AudioSource source;
      if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
        source = AudioSource.uri(Uri.parse(pathOrUrl));
      } else {
        source = AudioSource.uri(Uri.file(pathOrUrl));
      }
      await _player.setAudioSource(source);
      await _player.play();
    } catch (e) {
      rethrow;
    }
  }

  onNavToFlashcard(Deck deck) {
    getFlashcardsByKeys(deck.flashcardKeys);
    getStudiesCardsToday(deck.flashcardKeys);
    if (studiesCards.isEmpty) {
      _navigationService.showSnackBar(
        "You've already learned. Coming back later",
      );
    } else {
      _navigationService.navigate(FlashcardPage(deck: deck));
    }
  }

  onNavToAddFlashcard(Deck deck) {
    _navigationService.navigate(AddCardPage(deck: deck));
  }

  Future<void> getStudiesCardsToday(List<int> flashcardKeys) async {
    studiesCards = _flashCardRepo.getFlashcardsToStudyToday(flashcardKeys);
    notifyListeners();
  }

  onSelectedMeaning(CacheMeaning? meaning) {
    selectedMeaning = meaning;
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
