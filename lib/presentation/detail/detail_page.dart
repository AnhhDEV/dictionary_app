import 'dart:developer';

import 'package:dictionary/domain/model/dto/word_model.dart';
import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:dictionary/domain/model/local/cache_word.dart';
import 'package:dictionary/domain/view_model/flashcard_viewmodel.dart';
import 'package:dictionary/domain/view_model/word_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/model/dto/definition.dart';
import '../../domain/model/dto/meaning.dart';

class DetailPage extends StatelessWidget {
  final WordDto? word;
  final CacheWord? cacheWord;

  const DetailPage({super.key, required this.word, required this.cacheWord});

  @override
  Widget build(BuildContext context) {
    final wordViewModel = Provider.of<WordViewModel>(context);
    final flashcardViewModel = Provider.of<FlashcardViewModel>(context);

    final titleWord = word?.word ?? cacheWord?.word ?? '';
    final audioUrl = word?.getUrlAudio() ?? cacheWord?.audio;
    final phoneticText = word?.getPhonetic() ?? cacheWord?.phonetic ?? '';

    final meanings =
        word?.meanings ??
        cacheWord?.meanings
            .map(
              (m) => MeaningDto(
                partOfSpeech: m.partOfSpeech,
                definitions:
                    m.definitions
                        .map((d) => DefinitionDto(definition: d))
                        .toList(),
                synonyms: m.synonyms,
                antonyms: m.antonyms,
              ),
            )
            .toList() ??
        [];

    final cacheMeanings = meanings.map((e) => e.toCacheMeaning()).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(titleWord),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: PopupMenuButton(
              itemBuilder: (context) {
                return flashcardViewModel.decks.asMap().entries.map((deck) {
                  final index = deck.key;
                  final name = deck.value.name;
                  return PopupMenuItem<(int, String)>(
                    value: (index, name),
                    child: Text(name),
                  );
                }).toList();
              },
              onSelected: ((int, String) value) {
                final int index = value.$1;
                showDialog(
                  context: context,
                  builder: (context) {
                    return Consumer<FlashcardViewModel>(
                      builder: (context, vm, _) {
                        return  Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // QUAN TRỌNG
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButton<CacheMeaning>(
                                    isExpanded: true,
                                    value: vm.selectedMeaning,
                                    items: cacheMeanings.map((meaning) {
                                      return DropdownMenuItem<CacheMeaning>(
                                        value: meaning,
                                        child: Text(meaning.partOfSpeech),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      vm.onSelectedMeaning(value);
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    controller: vm.note,
                                    decoration: InputDecoration(
                                      labelText: 'Translation',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(onPressed: () {
                                    vm.addFlashcardToDeck(
                                      titleWord,
                                      audioUrl ?? '',
                                      phoneticText,
                                      vm.decks[index],
                                    );
                                  }, child: const Center(child: Text('Confirm')))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                );

              },
              child: const Icon(Icons.save),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(titleWord, style: KTextStyle.textStyle22),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (audioUrl != null) {
                      wordViewModel.playUrlAudio(audioUrl);
                    }
                  },
                  icon: Icon(Icons.volume_up),
                ),
                SizedBox(width: 8),
                Text(phoneticText, style: KTextStyle.textStyle18reuglar),
              ],
            ),
            SizedBox(height: 5),
            Divider(thickness: 2, color: Theme.of(context).colorScheme.primary),
            Expanded(
              child: ListView.builder(
                itemCount: meanings.length,
                itemBuilder: (context, index) {
                  final meaning = meanings[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$titleWord (${meaning.partOfSpeech})',
                        style: KTextStyle.textStyle18bold,
                      ),
                      SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            meaning.definitions.asMap().entries.map((entry) {
                              final defIndex = entry.key;
                              final def = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    def.definition,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  if (def.example != null &&
                                      def.example!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        top: 2,
                                      ),
                                      child: Text(
                                        '• ${def.example}',
                                        style: KTextStyle.textStyle16,
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  if (defIndex < meaning.definitions.length - 1)
                                    Divider(
                                      thickness: 1,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                  SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                      ),
                      if (index < meanings.length - 1)
                        Divider(
                          thickness: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
