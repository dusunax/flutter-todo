import 'package:flutter/material.dart';

class Todo {
  final int id;
  late String title;
  bool isCompleted;
  IconData? icon;

  Todo({required this.id, required this.title, this.isCompleted = false});
}

class ThemeColors {
  final Color backgroundColor;
  final Color dismissedBackgroundColor;
  final Color dismissedTextColor;
  final Color textColor;
  final Color activeColor;
  final Color deleteIconColor;

  ThemeColors({
    required this.backgroundColor,
    required this.dismissedBackgroundColor,
    required this.dismissedTextColor,
    required this.textColor,
    required this.activeColor,
    required this.deleteIconColor,
  });

  static ThemeColors get darkTheme => ThemeColors(
        textColor: Colors.white,
        backgroundColor: Colors.grey[900]!,
        dismissedTextColor: Colors.green,
        dismissedBackgroundColor: Colors.grey[700]!,
        activeColor: Colors.blue,
        deleteIconColor: Colors.red,
      );

  static ThemeColors get lightTheme => ThemeColors(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        dismissedTextColor: Colors.blue,
        dismissedBackgroundColor: Colors.grey[300]!,
        activeColor: Colors.blue,
        deleteIconColor: Colors.red,
      );
}

final _themeColors = {
  'dark': ThemeColors.darkTheme,
  'light': ThemeColors.lightTheme,
};
