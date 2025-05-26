import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/view_model/system_viewmodel.dart';
import 'package:dictionary/presentation/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootApp extends StatelessWidget {
  final NavigationService navigationService;

  const RootApp({super.key, required this.navigationService});

  @override
  Widget build(BuildContext context) {

    final isDark = context.watch<SystemViewModel>().isDarkMode;

    return MaterialApp(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      navigatorKey: navigationService.navigationKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      home: SearchPage(),
    );
  }
}
