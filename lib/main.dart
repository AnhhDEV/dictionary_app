
import 'package:dictionary/data/networking/ApiProvider.dart';
import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final ApiProvider api = ApiProvider();
  final NavigationService navigationService = NavigationService.instance;
  final player = AudioPlayer();
  runApp(WidgetTree(api: api, navigationService: navigationService, audioPlayer: player));
}
