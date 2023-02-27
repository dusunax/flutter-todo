import 'package:flutter/material.dart';
import 'package:todo/main.dart';

class Todo {
  final int id;
  final String title;
  bool isCompleted;
  IconData? icon;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.icon = Icons.hourglass_empty_rounded,
  });
}

class ThemeColors {
  final Color backgroundColor;
  final Color dismissedBackgroundColor;
  final Color textColor;
  final Color activeColor;
  final Color deleteIconColor;

  ThemeColors({
    required this.backgroundColor,
    required this.dismissedBackgroundColor,
    required this.textColor,
    required this.activeColor,
    required this.deleteIconColor,
  });
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // 클래스 멤버 변수
  bool _isDarkMode = false;

  // 투두 리스트 색상
  late ThemeColors themeColors;

  // 투두 리스트
  final List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    themeColors = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeColors(
            backgroundColor: Colors.white,
            dismissedBackgroundColor: const Color.fromARGB(255, 195, 195, 195),
            textColor: Colors.black,
            activeColor: Colors.grey,
            deleteIconColor: Colors.red[300]!,
          )
        : ThemeColors(
            backgroundColor: const Color.fromARGB(255, 42, 42, 42),
            dismissedBackgroundColor: const Color.fromARGB(255, 81, 81, 81),
            textColor: Colors.white,
            activeColor: Colors.grey,
            deleteIconColor: Colors.red[300]!,
          );
    MyApp.themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    MyApp.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {
      themeColors = MyApp.themeNotifier.value == ThemeMode.light
          ? ThemeColors(
              backgroundColor: Colors.white,
              dismissedBackgroundColor:
                  const Color.fromARGB(255, 195, 195, 195),
              textColor: Colors.black,
              activeColor: Colors.grey,
              deleteIconColor: Colors.red[300]!,
            )
          : ThemeColors(
              backgroundColor: const Color.fromARGB(255, 42, 42, 42),
              dismissedBackgroundColor: const Color.fromARGB(255, 81, 81, 81),
              textColor: Colors.white,
              activeColor: Colors.grey,
              deleteIconColor: Colors.red[300]!,
            );
    });
  }

  // 할 일 추가 함수
  void _addTodo() {
    // 다이얼로그를 띄워 입력받은 후 _todoList에 추가
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('할 일 추가'),
          content: TextField(
            autofocus: true,
            onSubmitted: (text) {
              setState(() {
                final newTodo = Todo(title: text, id: _todoList.length);
                _todoList.insert(0, newTodo); // 맨 앞에 추가
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  // 할 일 제거 함수
  void _removeTodo(int index) {
    setState(() {
      _todoList.removeAt(index); // 리스트에서 삭제
    });
  }

  // 체크박스 상태 변경 함수
  void _onCheckboxChanged(int index, bool value) {
    setState(() {
      final todo = _todoList[index];
      _todoList.removeAt(index);
      todo.isCompleted = value;
      _todoList.insert(value ? _todoList.length : 0, todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('체크 리스트'),
        actions: [
          IconButton(
            // 토글 부분
            onPressed: () {
              ThemeColors.;
              MyApp.themeNotifier.value =
                  _isDarkMode ? ThemeMode.dark : ThemeMode.light;
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = _todoList[index];

          final backgroundColor =
              todo.isCompleted ? Colors.grey.shade200 : Colors.transparent;
          final dismissedBackgroundColor =
              _isDarkMode ? const Color(0xFFC3C3C3) : const Color(0xFF515151);
          final textColor = _isDarkMode ? Colors.black : Colors.white;

          return Dismissible(
            key: ValueKey<Todo>(todo),
            onDismissed: (direction) {
              _removeTodo(index);
            },
            background: Container(
              color: dismissedBackgroundColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: dismissedBackgroundColor,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Container(
              color: backgroundColor,
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    color: textColor,
                    decoration:
                        todo.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        _onCheckboxChanged(index, value ?? false);
                      },
                      activeColor: Colors.grey,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[300]),
                      onPressed: () {
                        _removeTodo(index);
                      },
                    ),
                  ],
                ),
                leading: Icon(
                  todo.icon,
                  color: todo.isCompleted ? Colors.grey : null,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
