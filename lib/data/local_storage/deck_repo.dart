import 'package:dictionary/domain/model/local/deck.dart';
import 'package:hive/hive.dart';

class DeckRepository {

  final Box<Deck> _box;

  DeckRepository(this._box);

  //Create a deck
  Future<void> add(Deck deck) async {
     await _box.add(deck);
  }

  //Get all decks
  List<Deck> getAllDecks() {
    return _box.values.toList();
  }

  //Add flashcard key to a specific deck
  Future<void> addFlashcardToDeck(int deckKey, int flashcardKey) async {
    final deck = _box.get(deckKey);
    if(deck == null) return;
    if(!deck.flashcardKeys.contains(flashcardKey)) {
      deck.flashcardKeys.add(flashcardKey);
      await deck.save();
    }
  }

  //Get key of deck
  int? getKeyOfDeck(Deck deck) {
    return deck.key as int?;
  }

  //remove deck
  Future<void> removeDeck(int deckKey) async {
    await _box.delete(deckKey);
  }

  //remove flashcard from deck
  Future<void> removeFlashcardFromDeck(int deckKey, int flashcardKey) async {
    final deck = _box.get(deckKey);
    if(deck == null) return;
    deck.flashcardKeys.remove(flashcardKey);
    await deck.save();
  }

}