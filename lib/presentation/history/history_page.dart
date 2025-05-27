import 'package:dictionary/domain/view_model/word_viewmodel.dart';
import 'package:dictionary/util/k_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WordViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Searched Word', style: KTextStyle.textStyle18bold),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.getAllSearchedWords,
        child: ListView.builder(
          itemCount: viewModel.searchedWords.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () => viewModel.onNavToDetail(null, viewModel.searchedWords[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(
                          viewModel.searchedWords[i].word,
                          style: KTextStyle.textStyle16,
                        ),
                        SizedBox(width: 6,),
                        Text(
                          viewModel.searchedWords[i].phonetic ?? '',
                          style: KTextStyle.textStyle16,
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                        IconButton(
                          onPressed: () {
                            viewModel.toggleFavorite(viewModel.searchedWords[i]);
                          },
                          icon:
                          viewModel.searchedWords[i].isFavorite ?? false
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
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
