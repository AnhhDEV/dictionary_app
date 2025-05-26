import 'package:dictionary/data/local_storage/color_system_repo.dart';
import 'package:flutter/material.dart';

class SystemViewModel extends ChangeNotifier {
    late final ColorSystemRepository _repository;

    bool _isDarkMode = false;
    bool get isDarkMode => _isDarkMode;

    SystemViewModel() {
        _repository = ColorSystemRepository.instance;
        loadBrightnessMode();
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
