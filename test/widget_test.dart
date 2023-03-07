// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/main.dart';

void main() {
  testWidgets('Todo list adds new item', (WidgetTester tester) async {
    final directory = await getApplicationDocumentsDirectory();
    final databasePath = '${directory.path}/todo.db';

// Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(databasePath: databasePath));

// Verify that the initial todo list is empty
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('할 일 추가'), findsNothing);

// Tap the '+' icon to add new todo item
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

// Verify that the dialog appears
    expect(find.text('할 일 추가'), findsOneWidget);

// Enter a new todo item title
    await tester.enterText(find.byType(TextField), 'New Todo Item');
    await tester.pump();

// Tap the '추가' button to add new todo item
    await tester.tap(find.text('추가'));
    await tester.pumpAndSettle();

// Verify that the new todo item is added to the list
    expect(find.text('New Todo Item'), findsOneWidget);
  });
}
