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
  final PageController _pageController = PageController();
  late FlashcardViewModel viewModel;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
      viewModel.resetPage();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onQualitySelected(int quality) {
    final currentIndex = viewModel.currentPage;
    final flashcard = viewModel.studiesCards[currentIndex];
    viewModel.updateStatusOfFlashcard(flashcard, quality);

    if (currentIndex < viewModel.studiesCards.length ) {
      viewModel.onPageChange();
      _pageController.animateToPage(
        viewModel.currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<FlashcardViewModel>();
    final flashcards = viewModel.studiesCards;

    if (_cardKeys.length != flashcards.length) {
      _cardKeys
        ..clear()
        ..addAll(List.generate(flashcards.length, (_) => GlobalKey<FlipCardState>()));
    }

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: viewModel.setPage,
        itemCount: flashcards.length + 1,
        itemBuilder: (context, index) {
          if (index == flashcards.length) {
            if (!_hasCompleted) {
              _hasCompleted = true;
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              });
            }
            return Center(child: Text("Completed 🎉", style: KTextStyle.textStyle22));
          }

          final flashcard = flashcards[index];
          final color = KTextStyle.cardColors[index % KTextStyle.cardColors.length];
          final cardKey = _cardKeys[index];

          return Container(
            color: Colors.black38,
            child: Center(
              child: FlipCard(
                key: cardKey,
                direction: FlipDirection.HORIZONTAL,
                flipOnTouch: false,
                front: _buildFrontCard(flashcard, color, () => cardKey.currentState?.toggleCard()),
                back: _buildBackCard(flashcard, color),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard(flashcard, Color color, VoidCallback onFlip) {
    return Card(
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(flashcard.meaning.partOfSpeech.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.black87)),
                Text(flashcard.word, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.black87)),
                Row(
                  children: [
                    InkWell(
                      onTap: () => viewModel.playUrlAudio(flashcard.audio),
                      child: const Icon(Icons.volume_up, color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    Text(flashcard.phonetic, style: const TextStyle(fontSize: 20, color: Colors.black87)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: onFlip,
              icon: const Text("flip", style: TextStyle(color: Colors.black87)),
              label: const Icon(Icons.arrow_forward, color: Colors.black87),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                side: const BorderSide(color: Colors.black87),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard(flashcard, Color color) {
    return Card(
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: flashcard.meaning.definitions
                  .map<Widget>((e) => Text("• $e", style: const TextStyle(fontSize: 18, color: Colors.black87)))
                  .toList(),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [3, 2, 1, 0].map((score) {
                final emoji = ['😵‍', '😓', '🙂', '😎'][3 - score];
                return TextButton(
                  onPressed: () => _onQualitySelected(score),
                  child: Text(emoji, style: const TextStyle(fontSize: 35)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
