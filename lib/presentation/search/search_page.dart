import 'package:dictionary/domain/model/dto/word_model.dart';
import 'package:dictionary/domain/view_model/system_viewmodel.dart';
import 'package:dictionary/domain/view_model/word_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wordViewModel = Provider.of<WordViewModel>(context);
    final systemViewModel = Provider.of<SystemViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm', style: KTextStyle.textStyle18bold),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              systemViewModel.toggleBrightnessMode();
            },
            icon: Icon(
              systemViewModel.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      body: Column(
        children: [
          //search bar
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: SearchBar(
              focusNode: _searchFocusNode,
              controller: wordViewModel.wordController,
              keyboardType: TextInputType.text,
              leading: Icon(Icons.search),
              hintText: 'Tìm từ tiếng anh',
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                print('Change$value');
                wordViewModel.onSearchChanged();
              },
            ),
          ),
          //words
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: wordViewModel.words.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return InkWell(
                  splashColor: Colors.white60,
                  onTap: () {
                    wordViewModel.onNavToDetail(wordViewModel.words[i]);
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          left: 12,
                          right: 12,
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wordViewModel.words[i].word,
                                  style: KTextStyle.textStyle16,
                                  selectionColor: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      wordViewModel
                                              .words[i]
                                              .phonetics
                                              .isNotEmpty
                                          ? wordViewModel
                                                  .words[i]
                                                  .phonetics
                                                  .first
                                                  .text ??
                                              ''
                                          : '',
                                      style: KTextStyle.textStyle14,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      wordViewModel.words[i]
                                          .getAllPartOfSpeeches(),
                                      style: KTextStyle.textStyle14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(flex: 1, child: SizedBox()),
                            Icon(Icons.north_east, size: 20,),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
