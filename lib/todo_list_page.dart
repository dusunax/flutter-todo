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

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // 투두 리스트
  final List<Todo> _todoList = [];

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
                _todoList.insert(
                    0, Todo(title: text, id: _todoList.length)); // 맨 앞에 추가
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

  @override
  Widget build(BuildContext context) {
    // 다크모드 여부
    bool isDarkMode = MyApp.themeNotifier.value == ThemeMode.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('체크 리스트'),
        actions: [
          IconButton(
              // 토글 부분
              onPressed: () {
                MyApp.themeNotifier.value =
                    isDarkMode ? ThemeMode.dark : ThemeMode.light;
              },
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode))
        ],
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = _todoList[index];

          Color backgroundColor =
              isDarkMode ? Colors.white : Color.fromARGB(255, 42, 42, 42);
          Color dismissedBackgroundColor = isDarkMode
              ? Color.fromARGB(255, 195, 195, 195)
              : Color.fromARGB(255, 81, 81, 81);
          Color textColor = isDarkMode ? Colors.black : Colors.white;

          return Dismissible(
            key: ValueKey<Todo>(todo),
            onDismissed: (direction) {
              setState(() {
                _todoList.removeAt(index); // 리스트에서 삭제
              });
            },
            child: Container(
              color: todo.isCompleted
                  ? dismissedBackgroundColor
                  : backgroundColor, // 배경색 추가
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    color: todo.isCompleted ? Colors.grey : textColor,
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: todo.isCompleted,
                      onChanged: (checked) {
                        setState(() {
                          todo.isCompleted = checked ?? false;
                          if (todo.isCompleted) {
                            _todoList.removeAt(index);
                            _todoList.insert(_todoList.length, todo);
                          } else {
                            _todoList.removeAt(index);
                            _todoList.insert(0, todo);
                          }
                        });
                      },
                      activeColor: Colors.grey,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[300]),
                      onPressed: () => _removeTodo(index),
                    ),
                  ],
                ),
                leading: Icon(
                  todo.isCompleted
                      ? Icons.done_rounded
                      : Icons.hourglass_empty_rounded,
                  color: todo.isCompleted ? Colors.grey : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
