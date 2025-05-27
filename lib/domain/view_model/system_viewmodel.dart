import 'package:dictionary/data/local_storage/color_system_repo_impl.dart';
import 'package:flutter/material.dart';

class SystemViewModel extends ChangeNotifier {
    late final ColorSystemRepository _repository;

    bool _isDarkMode = false;
    bool get isDarkMode => _isDarkMode;

    int _currentIndex = 0;
    int get currentIndex => _currentIndex;

    SystemViewModel() {
        _repository = ColorSystemRepository.instance;
        loadBrightnessMode();
    }

    void onChangeIndex(int index) {
        _currentIndex = index;
        notifyListeners();
    }

    Future<void> loadBrightnessMode() async {
        final result = await _repository.getBrightnessMode();
        _isDarkMode = result ?? false;
        notifyListeners();
    }

    Future<void> toggleBrightnessMode() async {
        _isDarkMode = !_isDarkMode;
        await _repository.setBrightnessMode(_isDarkMode);
        notifyListeners();
    }
}
