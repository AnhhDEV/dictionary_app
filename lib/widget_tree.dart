import 'package:dictionary/data/local_storage/cache_word_repo.dart';
import 'package:dictionary/data/local_storage/searched_word_repo.dart';
import 'package:dictionary/data/networking/ApiProvider.dart';
import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/view_model/system_viewmodel.dart';
import 'package:dictionary/domain/view_model/word_viewmodel.dart';
import 'package:dictionary/root_app.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatelessWidget {
  final ApiProvider api;
  final NavigationService navigationService;
  final AudioPlayer audioPlayer;
  final SearchedWordRepository searchRepo;
  final CacheWordRepository cacheRepo;

  const WidgetTree({
    super.key,
    required this.api,
    required this.navigationService,
    required this.audioPlayer,
    required this.searchRepo,
    required this.cacheRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => WordViewModel(
                navigationService,
                api,
                audioPlayer,
                cacheRepo,
                searchRepo,
              ),
        ),
        ChangeNotifierProvider(create: (_) => SystemViewModel()),
      ],
      child: RootApp(navigationService: navigationService),
    );
  }
}
