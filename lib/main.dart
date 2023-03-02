import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/todo_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
              title: '체크 리스트',
              theme: ThemeData(
                primarySwatch: Colors.orange,
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey[800],
                  shadowColor: Colors.grey[100],
                  centerTitle: true,
                ),
              ),
              darkTheme: ThemeData.dark(),
              themeMode: currentMode,
              localizationsDelegates: const <LocalizationsDelegate<Object>>[
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // ignore: prefer_const_literals_to_create_immutables
              supportedLocales: [
                const Locale('en', ''), // 영어
                const Locale('ko', ''), // 한국어
              ],
              home: const TodoListPage());
        });
  }
}
