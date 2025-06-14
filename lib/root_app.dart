import 'package:dictionary/data/service/navigator.dart';
import 'package:dictionary/domain/view_model/system_viewmodel.dart';
import 'package:dictionary/presentation/favorite/favorite_page.dart';
import 'package:dictionary/presentation/flash_card/deck_page.dart';
import 'package:dictionary/presentation/history/history_page.dart';
import 'package:dictionary/presentation/home/home_page.dart';
import 'package:dictionary/presentation/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootApp extends StatelessWidget {
  final NavigationService navigationService;

  const RootApp({super.key, required this.navigationService});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SystemViewModel>().isDarkMode;
    int currentIndex = context.watch<SystemViewModel>().currentIndex;
    final viewModel = Provider.of<SystemViewModel>(context);
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
      home: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            SearchPage(),
            HistoryPage(),
            FavoritePage(),
            DeckPage()
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.search), label: 'Tìm kiếm'),
            NavigationDestination(icon: Icon(Icons.history), label: 'Lịch sử'),
            NavigationDestination(icon: Icon(Icons.favorite), label: 'Từ đã lưu'),
            NavigationDestination(icon: Icon(Icons.folder_open), label: 'Flashcard'),
          ],
          onDestinationSelected: (value) {
            viewModel.onChangeIndex(value);
          },
          selectedIndex: currentIndex,
        ),
      ),
    );
  }

}



