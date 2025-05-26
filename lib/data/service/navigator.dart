import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  navigate(Widget widget) {
    return navigationKey.currentState!.push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  goBack() {
    return navigationKey.currentState!.pop();
  }

  showLoader() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: navigationKey.currentContext!,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(navigationKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
