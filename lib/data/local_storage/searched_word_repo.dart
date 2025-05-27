import 'package:dictionary/domain/model/local/cache_word.dart';
import 'package:dictionary/domain/model/local/searched_word.dart';
import 'package:hive/hive.dart';

class SearchedWordRepository {

  final Box<SearchedWord> _box;

  SearchedWordRepository(this._box);


  Future<void> add(int cacheWordKey) async {
    final searchedWord = SearchedWord(
      cacheWordKey,
      DateTime.now().toIso8601String(),
    );
    await _box.add(searchedWord);
  }

  List<SearchedWord> getAll() {
    return _box.values.toList().reversed.toList();
  }

}