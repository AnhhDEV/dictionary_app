import 'package:dictionary/domain/model/dto/word_model.dart';
import 'package:dictionary/domain/model/local/cache_word.dart';
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

    final titleWord = word?.word ?? cacheWord?.word ?? '';
    final audioUrl = word?.getUrlAudio() ?? cacheWord?.audio;
    final phoneticText = word?.getPhonetic() ?? cacheWord?.phonetic ?? '';

    final meanings = word?.meanings ??
        cacheWord?.meanings
            .map((m) => MeaningDto(
          partOfSpeech: m.partOfSpeech,
          definitions: m.definitions
              .map((d) => DefinitionDto(definition: d))
              .toList(),
          synonyms: m.synonyms,
          antonyms: m.antonyms,
        ))
            .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(titleWord),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.star, color: Colors.yellowAccent),
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
                        children: meaning.definitions.asMap().entries.map((entry) {
                          final defIndex = entry.key;
                          final def = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(def.definition, style: TextStyle(fontSize: 16)),
                              if (def.example != null && def.example!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6, top: 2),
                                  child: Text('• ${def.example}', style: KTextStyle.textStyle16),
                                ),
                              SizedBox(height: 10),
                              if (defIndex < meaning.definitions.length - 1)
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).colorScheme.secondary,
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
