import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'todo_list_page.dart';
import 'package:path_provider/path_provider.dart';
import 'helpers/todo_database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  final databasePath = '${directory.path}/todo.db';
  runApp(MyApp(databasePath: databasePath));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.databasePath}) : super(key: key);

  final String databasePath;

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return FutureBuilder(
            future:
                TodoDatabaseHelper.instance.init(databasePath: databasePath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error initializing database'),
                  );
                } else {
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
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        });
  }
}
