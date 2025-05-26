import 'package:dictionary/domain/model/dto/word_model.dart';
import 'package:dictionary/domain/view_model/word_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final WordDto word;

  const DetailPage({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final wordViewModel = Provider.of<WordViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(word.word),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.star, color: Colors.yellowAccent),
          ),
        ],
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            //word name
            Text(word.word, style: KTextStyle.textStyle22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //audio
              children: [
                IconButton(onPressed: () {
                  final url = word.getUrlAudio();
                  if(url != null) {
                    wordViewModel.playUrlAudio(url);
                  } 
                }, icon: Icon(Icons.volume_up)),
                SizedBox(width: 8),
                //phonetic
                Text(word.getPhonetic(), style: KTextStyle.textStyle18reuglar),
              ],
            ),
            SizedBox(height: 5),
            Divider(thickness: 2, color: Theme
                .of(context)
                .colorScheme
                .primary),
            //meanings
            Expanded(
              child: ListView.builder(
                itemCount: word.meanings.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //parch of speech
                      Text('${word.word} ${word.meanings[index].partOfSpeech}', style: KTextStyle.textStyle18bold),
                      SizedBox(height: 5),
                      //definitions
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: word.meanings[index].definitions.asMap().entries.map((entry) {
                          final defIndex = entry.key;
                          final def = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                def.definition,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if (def.example != null && def.example!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6, top: 2),
                                  child: Text(
                                    '• ${def.example}',
                                    style: KTextStyle.textStyle16,
                                  ),
                                ),
                              SizedBox(height: 10,),
                              if(defIndex < word.meanings[index].definitions.length - 1)
                                Divider(
                                  thickness: 1,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .secondary,
                                ),
                              SizedBox(height: 10,)
                            ],
                          );
                        },).toList()
                      ),
                      if(index < word.meanings.length - 1)
                        Divider(
                          thickness: 2,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
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
