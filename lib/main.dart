import 'package:dictionary/data/local_storage/cache_word_repo.dart';
import 'package:dictionary/data/local_storage/searched_word_repo.dart';
import 'package:dictionary/data/networking/ApiProvider.dart';
import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/model/local/cache_meaning.dart';
import 'package:dictionary/domain/model/local/cache_word.dart';
import 'package:dictionary/domain/model/local/searched_word.dart';
import 'package:dictionary/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';

import 'data/service/local_database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //api
  final ApiProvider api = ApiProvider();
  //navigation service
  final NavigationService navigationService = NavigationService.instance;
  //audio
  final player = AudioPlayer();
  //hive
  final (cacheRepo, searchRepo, flashcardRepo, deckRepo) = await LocalDatabaseService.init();

  runApp(
    WidgetTree(
      api: api,
      navigationService: navigationService,
      audioPlayer: player,
      cacheRepo: cacheRepo,
      searchRepo: searchRepo,
      flashCardRepository: flashcardRepo,
      deckRepository: deckRepo
    ),
  );
}
