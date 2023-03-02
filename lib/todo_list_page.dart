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
  bool _isCompleted = false;
  int _plantCm = 0;

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
                final lastTodo = _todoList.isNotEmpty ? _todoList.last : null;
                final newTodo = Todo(title: text, id: (lastTodo?.id ?? 0) + 1);
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
  void _removeTodoById(int id) {
    setState(() {
      _todoList.removeWhere((todo) => todo.id == id); // 리스트에서 삭제
    });
  }

  // 체크박스 상태 변경 함수
  void _onCheckboxChanged(int index, bool isCompleted) {
    setState(() {
      final todo = _todoList[index];
      _removeTodoById(todo.id);
      todo.isCompleted = isCompleted;
      _todoList.insert(isCompleted ? _todoList.length : 0, todo);

      if (isCompleted) {
        final todo = _todoList[index];
        // 완료 시 plant_cm 증가
        todo.plantCm += 1;
        // 이미지 표시 후 0.5초 후 사라지도록 설정
        _isCompleted = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _isCompleted = false;
          });
        });
      }
    });
  }

  /// 할 일 수정 함수 : 완료되지 않은 리스트를 클릭 시, 수정합니다.
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
    _plantCm = _todoList.length * 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('체크 리스트'),
        centerTitle: true,
        actions: [
          IconButton(
            // 토글 부분
            onPressed: () {
              bool currentMode = !_isDarkMode;
              MyApp.themeNotifier.value =
                  currentMode ? ThemeMode.dark : ThemeMode.light;
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = _todoList[index];

            final backgroundColor = todo.isCompleted
                ? _themeColors.dismissedBackgroundColor
                : Colors.transparent;

            final textColor = _themeColors.textColor;

            return Dismissible(
                key: ValueKey<Todo>(todo),
                onDismissed: (direction) => _removeTodoById(todo.id),
                background: Container(
                  color: _themeColors.dismissedBackgroundColor,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                ),
                secondaryBackground: Container(
                  // Card 위젯으로 변경
                  color: _themeColors.dismissedBackgroundColor,
                  // elevation: 4.0,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    todo.isCompleted ? null : _editTodoItem(todo);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: backgroundColor,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "${todo.id}.  ${todo.title} ",
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
                            _onCheckboxChanged(todo.id, value ?? false);
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

        Positioned(
          left: 0,
          right: 0,
          bottom: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_plantCm cm',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 15, 173, 81)),
              ),
            ],
          ),
        ),

        // 애니메이션
        Positioned(
          left: 0,
          right: 0,
          bottom: 14,
          child: AnimatedOpacity(
            opacity: _isCompleted ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 2000),
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/2970/2970461.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
        Positioned(
          left: 24,
          bottom: 9,
          child: AnimatedOpacity(
            opacity: _isCompleted ? 1.0 : 0.2,
            duration: const Duration(milliseconds: 500),
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/9582/9582758.png',
              width: 90,
              height: 90,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          height: 20,
          left: 0,
          right: 0,
          child: Container(
            color: const Color(0xFFB6766B),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: Icon(
          Icons.add_reaction_rounded,
          color: _themeColors.iconColor,
        ),
      ),
    );
  }
}
