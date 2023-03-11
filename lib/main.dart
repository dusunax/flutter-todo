import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'todo_list_page.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  final databasePath = '${directory.path}/todo.db';
  runApp(MyApp(databasePath: databasePath));
}

class MyApp extends StatefulWidget {
  final String databasePath;

  const MyApp({super.key, required this.databasePath});

  // define the themeNotifier as a static field
  static final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            themeMode: currentMode,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ko', ''), // Korean
            ],
            home: const TodoListPage(),
          );
        });
  }
}
