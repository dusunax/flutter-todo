import 'package:flutter/material.dart';
import 'package:todo/main.dart';
import 'package:todo/todo.dart';

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
  late ThemeColors _themeColors;

  // 투두 리스트
  final List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    _isDarkMode = MyApp.themeNotifier.value == ThemeMode.dark;
    _themeColors = _isDarkMode ? ThemeColors.darkTheme : ThemeColors.lightTheme;
    MyApp.themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    MyApp.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {
      _isDarkMode = MyApp.themeNotifier.value == ThemeMode.dark;
      _themeColors =
          _isDarkMode ? ThemeColors.darkTheme : ThemeColors.lightTheme;
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

  /** 할 일 수정 함수 : 완료되지 않은 리스트를 클릭 시, 수정합니다.*/
  void _editTodoItem(Todo todo) {
    final titleController = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('할 일 수정'),
          content: TextField(
            autofocus: true,
            controller: titleController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todo.title = titleController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('체크 리스트'),
        centerTitle: true,
        actions: [
          IconButton(
            // 토글 부분
            onPressed: () {
              MyApp.themeNotifier.value =
                  _isDarkMode ? ThemeMode.dark : ThemeMode.light;
              _isDarkMode = !_isDarkMode;
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = _todoList[index];

          final backgroundColor = todo.isCompleted
              ? _themeColors.dismissedBackgroundColor
              : Colors.transparent;

          final textColor = _themeColors.textColor;

          return Dismissible(
              key: ValueKey<Todo>(todo),
              onDismissed: (direction) => _removeTodo(index),
              background: Container(
                color: _themeColors.dismissedBackgroundColor,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
              ),
              secondaryBackground: Container(
                color: _themeColors.dismissedBackgroundColor,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () {
                  todo.isCompleted ? null : _editTodoItem(todo);
                },
                child: Container(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        color: textColor,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          _onCheckboxChanged(index, value ?? false);
                        },
                        activeColor: _themeColors.activeColor),
                    leading: Icon(
                      todo.isCompleted ? Icons.check : Icons.hourglass_bottom,
                      color: todo.isCompleted
                          ? _themeColors.dismissedTextColor
                          : _themeColors.dismissedBackgroundColor,
                    ),
                  ),
                ),
              ));
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
