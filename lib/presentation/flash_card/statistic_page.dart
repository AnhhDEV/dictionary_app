import 'package:dictionary/domain/model/local/flashcard_data.dart';
import 'package:dictionary/domain/model/local/word_flashcard.dart';
import 'package:dictionary/domain/view_model/flashcard_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late FlashcardViewModel viewModel;
  late TextEditingController searchController;
  List<WordFlashcard>? cards = [];
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
    cards = viewModel.flashcardData?.getAllCards();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          SizedBox(
            width: screenWidth - 50,
            child: SearchBar(
              autoFocus: false,
              focusNode: focusNode,
              elevation: WidgetStateProperty.all(0),
              trailing: [Icon(Icons.search)],
              keyboardType: TextInputType.text,
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surface,
              ),
              onChanged: (String value) {
                setState(() {
                  cards = viewModel.filterList(value, cards ?? []);
                });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    //all button
                    TextButton(
                      onPressed: () {
                        setState(() {
                          cards = viewModel.flashcardData?.getAllCards();
                        });
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Tất cả (${viewModel.flashcardData?.getFlashcardLength() ?? ''})',
                        style: KTextStyle.textStyle16,
                      ),
                    ),
                    //remembered button
                    TextButton(
                      onPressed: () {
                        setState(() {
                          cards = viewModel.flashcardData?.getRememberedCards();
                        });
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Đã học (${viewModel.flashcardData?.rememberedFlashcards.length ?? ''})',
                        style: KTextStyle.textStyle16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          cards =
                              viewModel.flashcardData?.getUnrememberedCards();
                        });
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Chưa học (${viewModel.flashcardData?.unrememberedFlashcards.length ?? ''})',
                        style: KTextStyle.textStyle16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    padding: EdgeInsets.all(8),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children:
                        (cards ?? []).map((e) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1.0,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.word,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    e.phonetic,
                                    style: KTextStyle.textStyle14,
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          viewModel.playAudio(e.audio);
                                        },
                                        icon: const Icon(Icons.volume_up),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
