import 'package:dictionary/domain/model/local/deck.dart';
import 'package:dictionary/domain/view_model/flashcard_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flip_card/flip_card.dart';

class FlashcardPage extends StatefulWidget {
  final Deck? deck;

  const FlashcardPage({super.key, this.deck});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final List<GlobalKey<FlipCardState>> _cardKeys = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context);
    final flashcards = viewModel.flashcards;

    if (_cardKeys.length != flashcards.length) {
      _cardKeys.clear();
      _cardKeys.addAll(
        List.generate(flashcards.length, (_) => GlobalKey<FlipCardState>()),
      );
    }

    return Scaffold(
      body: PageView.builder(
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = flashcards[index];
          final color = KTextStyle.getRandomColor();
          final cardKey = _cardKeys[index];

          return Container(
            color: Colors.black38,
            child: Center(
              child: FlipCard(
                key: cardKey,
                direction: FlipDirection.HORIZONTAL,
                flipOnTouch: false,
                front: _frontCard(
                  flashcard.word,
                  flashcard.phonetic,
                  flashcard.meaning.partOfSpeech,
                  color,
                  () {
                    cardKey.currentState?.toggleCard();
                  },
                  () {
                    viewModel.playUrlAudio(flashcard.audio);
                  },
                ),
                back: _backCard(color, flashcard.meaning.definitions, () {
                  cardKey.currentState?.toggleCard();
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _backCard(Color color, List<String> definitions, VoidCallback onFlip) {
    return Card(
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...definitions.map(
                    (e) => Text(
                      "• $e",
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: OutlinedButton.icon(
                onPressed: onFlip,
                icon: const Text(
                  "flip",
                  style: TextStyle(color: Colors.black87),
                ),
                label: const Icon(Icons.arrow_forward, color: Colors.black87),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  side: const BorderSide(color: Colors.black87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _frontCard(
    String text,
    String phonetic,
    String partOfSpeech,
    Color color,
    VoidCallback onFlip,
    VoidCallback playAudio,
  ) {
    return Card(
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partOfSpeech.toUpperCase(),
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        splashColor: Colors.black12,
                        onTap: () {
                          playAudio();
                        }, //
                        child: const Icon(
                          Icons.volume_up,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        phonetic,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: OutlinedButton.icon(
                onPressed: onFlip,
                icon: const Text(
                  "flip",
                  style: TextStyle(color: Colors.black87),
                ),
                label: const Icon(Icons.arrow_forward, color: Colors.black87),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  side: const BorderSide(color: Colors.black87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
