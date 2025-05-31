import 'package:dictionary/domain/view_model/flashcard_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeckPage extends StatelessWidget {
  const DeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FlashcardViewModel viewModel = Provider.of<FlashcardViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Bộ flashcard'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {
                viewModel.getAllCards();
            }, icon: Icon(Icons.auto_graph)),
          ),
        ],
      ),
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
                          autofocus: false,
                          controller: viewModel.name,
                          decoration: InputDecoration(hintText: 'Tên'),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          autofocus: false,
                          controller: viewModel.description,
                          decoration: InputDecoration(hintText: 'Mô tả'),
                        ),
                        SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            viewModel.createDeck();
                            viewModel.pop();
                          },
                          child: Text('Tạo'),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              viewModel.decks[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                            Spacer(),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'Delete') {
                                  viewModel.removeDeck(viewModel.decks[index]);
                                } else if(value == 'add') {
                                  viewModel.onNavToAddFlashcard(viewModel.decks[index]);
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      value: 'add',
                                      child: Row(
                                        children: [
                                          Icon(Icons.add_circle_outline),
                                          SizedBox(width: 5),
                                          Text('Thêm card mới'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline_outlined),
                                          SizedBox(width: 5),
                                          Text('Xóa bộ flashcard'),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          ],
                        ),
                        Text(
                          'Số lượng thẻ: ${viewModel.decks[index].flashcardKeys.length}',
                          style: KTextStyle.textStyle16,
                        ),
                        Text(
                          'Từ chưa học: ${viewModel.counts[index].notLearned}',
                          style: KTextStyle.textStyle16,
                        ),
                        Text(
                          'Từ hay quên: ${viewModel.counts[index].fuzzy}',
                          style: KTextStyle.textStyle16,
                        ),
                        Text(
                          'Từ đã học: ${viewModel.counts[index].remembered}',
                          style: KTextStyle.textStyle16,
                        ),
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
