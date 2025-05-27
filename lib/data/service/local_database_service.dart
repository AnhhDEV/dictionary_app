import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../domain/model/local/cache_meaning.dart';
import '../../domain/model/local/cache_word.dart';
import '../../domain/model/local/searched_word.dart';
import '../local_storage/cache_word_repo.dart';
import '../local_storage/searched_word_repo.dart';

class LocalDatabaseService {
  static Future<(CacheWordRepository, SearchedWordRepository)> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CacheMeaningAdapter());
    Hive.registerAdapter(CacheWordAdapter());
    Hive.registerAdapter(SearchedWordAdapter());

    final cacheBox = await Hive.openBox<CacheWord>('cache_words');
    final searchedBox = await Hive.openBox<SearchedWord>('searched_words');

    return (
    CacheWordRepository(cacheBox),
    SearchedWordRepository(searchedBox),
    );
  }
}