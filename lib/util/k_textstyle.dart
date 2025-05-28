import 'dart:math';

import 'package:flutter/material.dart';

class KTextStyle {

  static final textStyle22 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w500);

  static final textStyle18bold = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500);

  static final textStyle18reuglar = TextStyle(
      fontSize: 18, fontWeight: FontWeight.normal);

  static final textStyle16 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.normal
  );

  static final textStyle14 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal
  );

  static final List<Color> cardColors = [
    Color(0xFFffd01c), // Vàng sáng
    Color(0xFF6ee778), // Xanh lá chanh
    Color(0xFFFFA500), // Cam sáng
    Color(0xFFFF4F87), // Hồng neon
    Color(0xFF00BFFF), // Xanh dương sáng
    Color(0xFFDA70D6), // Tím sáng
    Color(0xFF40E0D0), // Ngọc lam
    Color(0xFFF5F5F5), // Trắng khói
  ];

  static Color getRandomColor() {
    return cardColors[Random().nextInt(cardColors.length)];
  }
}