import 'dart:async';
import 'dart:developer';

import 'package:dictionary/data/local_storage/cache_word_repo.dart';
import 'package:dictionary/data/local_storage/searched_word_repo.dart';
import 'package:dictionary/data/networking/ApiProvider.dart';
import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/model/dto/word_model.dart';
import 'package:dictionary/domain/model/local/cache_word.dart';
import 'package:dictionary/presentation/detail/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../model/dto/word_score.dart';

class WordViewModel extends ChangeNotifier {
  final NavigationService _navigatorService;
  final ApiProvider _api;
  final AudioPlayer _audioPlayer;
  final CacheWordRepository cacheWordRepository;
  final SearchedWordRepository searchedWordRepository;

  TextEditingController wordController = TextEditingController();
  List<WordDto> words = [];
  List<WordScoreDto> sgtWords = [];
  List<CacheWord> searchedWords = [];
  List<CacheWord> favoriteWords = [];
  Timer? _debounce;

  WordViewModel(
    this._navigatorService,
    this._api,
    this._audioPlayer,
    this.cacheWordRepository,
    this.searchedWordRepository,
  ) {
    getAllSearchedWords();
    getAllFavoriteWords();
  }

  Future<void> getAllFavoriteWords() async {
    favoriteWords = searchedWords.map((e) {
      if(e.isFavorite == true) {
        return e;
      }
    },).whereType<CacheWord>().toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(CacheWord word) async {
    final newStatus = !(word.isFavorite ?? false);
    final key = cacheWordRepository.getKeyByWord(word.word);
    if (key != null) {
      await cacheWordRepository.updateFavoriteStatus(key, newStatus);
      await getAllFavoriteWords();
      log("length: ${favoriteWords.length}");
      notifyListeners();
    }
  }

  Future<void> getAllSearchedWords() async {
    searchedWords =
        searchedWordRepository
            .getAll()
            .map((word) {
              final key = word.keyWord;
              return cacheWordRepository.getByKey(key);
            })
            .whereType<CacheWord>()
            .toList();
    notifyListeners();
  }

  void onNavToDetail(WordDto? word, CacheWord? cacheWord) async {
    _navigatorService.navigate(DetailPage(word: word, cacheWord: cacheWord));
    if(word != null) {
      await addSearchedWord(word);
    }
  }

  addSearchedWord(WordDto wordDto) async {
    // final start = DateTime.now();
    var existing = cacheWordRepository.getByWord(wordDto.word);
    if (existing == null) {
      final cacheWord = convertToCacheWord(wordDto);
      await cacheWordRepository.add(cacheWord);
      final key = cacheWordRepository.getKeyByWord(wordDto.word);
      if (key == null) return;
      await searchedWordRepository.add(key);
    }
    // print('⏱ Add to Hive took: ${DateTime.now().difference(start).inMilliseconds}ms');
  }

  Future<void> playUrlAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      rethrow;
    }
  }

  searchSuggestedWord() async {
    final resData = await _api.searchWord(wordController.text.trim());
    sgtWords =
        resData
            .map<WordScoreDto>((item) => WordScoreDto.fromJson(item))
            .toList();
    if (sgtWords.isNotEmpty) {
      for (var sgtWord in sgtWords) {
        searchWord(sgtWord.word);
      }
    } else {
      _navigatorService.showSnackBar('Không tìm được từ');
    }
  }

  searchWord(String word) async {
    final resData = await _api.findDetailWord(word);
    if (resData.isNotEmpty) {
      WordDto newWord = WordDto.fromJson(resData[0]);
      words.add(newWord);
      notifyListeners();
    }
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      words = [];
      if (wordController.text.isNotEmpty) {
        searchSuggestedWord();
      }
    });
  }
}
