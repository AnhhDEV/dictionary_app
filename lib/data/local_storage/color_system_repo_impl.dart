
import 'package:dictionary/util/alias.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorSystemRepository {

  static final ColorSystemRepository instance = ColorSystemRepository._internal();

  ColorSystemRepository._internal();

  @override
  Future<bool?> getBrightnessMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Alias.brightnessAlias);
  }

  @override
  Future<void> setBrightnessMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Alias.brightnessAlias, isDark);
  }

}