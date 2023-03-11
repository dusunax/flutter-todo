import 'package:flutter/material.dart';

const String tableTodo = 'todos';

class Todo {
  final int id;
  late String title;
  bool isChecked;
  IconData? icon;
  int plantCm; // 화분의 높이 정보를 저장하는 필드

  Todo({
    required this.id,
    required this.title,
    this.isChecked = false,
    this.plantCm = 0, // 화분의 높이를 0으로 초기화
  });
}

class TodoDBType {
  static const String tableTodos = 'todos';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnIsChecked = 'isChecked';

  static const List<String> values = [columnId, columnTitle, columnIsChecked];

  int id;
  String title;
  bool isChecked;

  TodoDBType({this.id = 0, required this.title, this.isChecked = false});

  Map<String, dynamic> toMap() {
    return {
      columnTitle: title,
      columnIsChecked: isChecked ? 1 : 0,
    };
  }

  TodoDBType copy({
    int? id,
    String? title,
    bool? isChecked,
  }) =>
      TodoDBType(
        id: id ?? this.id,
        title: title ?? this.title,
        isChecked: isChecked ?? this.isChecked,
      );

  factory TodoDBType.fromMap(Map<String, dynamic> map) {
    return TodoDBType(
      id: map[columnId],
      title: map[columnTitle],
      isChecked: map[columnIsChecked] == 1,
    );
  }
}

class ThemeColors {
  final Color backgroundColor;
  final Color dismissedBackgroundColor;
  final Color dismissedTextColor;
  final Color textColor;
  final Color activeColor;
  final Color deleteIconColor;
  final Color iconColor;

  ThemeColors({
    required this.backgroundColor,
    required this.dismissedBackgroundColor,
    required this.dismissedTextColor,
    required this.textColor,
    required this.activeColor,
    required this.deleteIconColor,
    required this.iconColor,
  });

  static ThemeColors get darkTheme => ThemeColors(
      textColor: Colors.white,
      backgroundColor: Colors.grey[900]!,
      dismissedTextColor: Colors.green,
      dismissedBackgroundColor: Colors.grey[700]!,
      activeColor: Colors.blue,
      deleteIconColor: Colors.red,
      iconColor: Colors.black);

  static ThemeColors get lightTheme => ThemeColors(
      textColor: Colors.black,
      backgroundColor: Colors.white,
      dismissedTextColor: Colors.blue,
      dismissedBackgroundColor: Colors.grey[300]!,
      activeColor: Colors.blue,
      deleteIconColor: Colors.red,
      iconColor: Colors.white);
}
