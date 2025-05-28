import 'package:dictionary/domain/view_model/flashcard_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeckPage extends StatelessWidget {
  const DeckPage({super.key});

  @override
  Widget build(BuildContext context) {

    final FlashcardViewModel viewModel = Provider.of<FlashcardViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text('Decks'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: viewModel.name,
                          decoration: InputDecoration(hintText: 'Name'),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: viewModel.description,
                          decoration: InputDecoration(hintText: 'Description'),
                        ),
                        SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            viewModel.createDeck();
                            viewModel.pop();
                          },
                          child: Text('Create a deck'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.getAllDecks(),
        child: ListView.builder(
          itemCount: viewModel.decks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                viewModel.onNavToFlashcard(viewModel.decks[index]);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.decks[index].name,
                          style: KTextStyle.textStyle16,
                        ),
                        Text(
                          viewModel.decks[index].description,
                          style: KTextStyle.textStyle14,
                        ),
                        Text(
                          'Number of cards: ${viewModel.decks[index].flashcardKeys.length}',
                          style: KTextStyle.textStyle14,
                        ),
                        Text(
                          'Not learned words: ${viewModel.counts[index].notLearned}',
                          style: KTextStyle.textStyle14,
                        ),
                        Text(
                          'Fuzzy words: ${viewModel.counts[index].fuzzy}',
                          style: KTextStyle.textStyle14,
                        ),
                        Text(
                          'Learned words: ${viewModel.counts[index].remembered}',
                          style: KTextStyle.textStyle14,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
