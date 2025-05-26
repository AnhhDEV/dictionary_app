import 'dart:async';
import 'dart:math';

import 'package:dictionary/data/networking/ApiProvider.dart';
import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/model/dto/word_model.dart';
import 'package:dictionary/presentation/detail/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../model/dto/word_score.dart';

class WordViewModel extends ChangeNotifier {
  final NavigationService _navigatorService;
  final ApiProvider _api;
  final AudioPlayer _audioPlayer;

  TextEditingController wordController = TextEditingController();
  List<WordDto> words = [];
  List<WordScoreDto> sgtWords = [];
  Timer? _debounce;

  WordViewModel(this._navigatorService, this._api, this._audioPlayer);

  void onNavToDetail(WordDto word) {
    _navigatorService.navigate(DetailPage(word: word));
  }

  Future<void> playUrlAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch(e) {
      rethrow;
    }
  }

  searchSuggestedWord() async {
      final resData = await _api.searchWord(wordController.text.trim());
      sgtWords = resData.map<WordScoreDto>((item) => WordScoreDto.fromJson(item)).toList();
      if(sgtWords.isNotEmpty) {
          for (var sgtWord in sgtWords) {
            searchWord(sgtWord.word);
          }
      } else {
        _navigatorService.showSnackBar('Không tìm được từ');
      }
  }

  searchWord(String word) async {
    final resData = await _api.findDetailWord(word);
    if(resData.isNotEmpty) {
      WordDto newWord = WordDto.fromJson(resData[0]);
      words.add(newWord);
      notifyListeners();
    }
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      words = [];
      if(wordController.text.isNotEmpty) {
        searchSuggestedWord();
      }
    });
  }
}
