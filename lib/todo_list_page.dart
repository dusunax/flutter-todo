import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todo/main.dart';
import 'package:todo/todo.dart';
import 'package:todo/helpers/todo_database_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  // db instance
  late String appDocumentsDirectory;
  final dbHelper = TodoDatabaseHelper.instance;

  // 투두 리스트
  List<TodoDBType>? _todoList;
  // final List<Todo> _todoList = [];

  // 클래스 멤버 변수
  bool _isDarkMode = false;
  bool _isCheckboxClicked = false;
  int _plantCm = 0;

  // 투두 리스트 색상
  late ThemeColors _themeColors;

  @override
  void initState() {
    super.initState();
    _isDarkMode = MyApp.themeNotifier.value == ThemeMode.dark;
    _themeColors = _isDarkMode ? ThemeColors.darkTheme : ThemeColors.lightTheme;
    MyApp.themeNotifier.addListener(_onThemeChanged);

    _initData();
  }

  Future<void> _initData() async {
    final directory = await getApplicationDocumentsDirectory();
    appDocumentsDirectory = directory.path;

    final todoList = await dbHelper.readAll();
    // ignore: avoid_print
    print(todoList);
    setState(() {
      _todoList = todoList;
    });
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

  // -------------------함수 시작-----------------------------------

  // 할 일 추가 함수
  void _addTodo() async {
    // 다이얼로그를 띄워 입력받은 후 db에 추가
    final newTodo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String? title;
        return AlertDialog(
          title: const Text('할 일 추가'),
          content: TextField(
            autofocus: true,
            onChanged: (text) {
              title = text;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                if (title == null || title!.isEmpty) {
                  return;
                }
                final todo = TodoDBType(
                  id: _todoList?.length ?? 1,
                  title: title!,
                );

                final createdTodo = await dbHelper.create(todo);
                // ignore: use_build_context_synchronously
                Navigator.pop(context, createdTodo);
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
    if (newTodo != null) {
      setState(() {
        _todoList ??= []; // null일 경우에 빈 배열로 초기화
        _todoList!.insert(0, newTodo); // 맨 앞에 추가
      });
    }
  }

  // 할 일 제거 함수
  void _removeTodoById(int id) async {
    final todo = _todoList?.firstWhereOrNull((todo) => todo.id == id);
    if (todo != null) {
      await dbHelper.delete(todo); // db에서 삭제
      setState(() {
        _todoList?.removeWhere((todo) => todo.id == id); // 리스트에서 삭제
      });
    }
  }

  // 체크박스 상태 변경 함수
  void _onCheckboxChanged(int id, bool isChecked) async {
    setState(() {
      // firstWhere : 첫번째 매치를 찾는 함수 ex) Array.filter
      final todo = _todoList?.firstWhere((todo) => todo.id == id);
      if (_todoList == null || todo == null) return;

      todo.isChecked = isChecked;

      // DB에서 업데이트
      dbHelper.update(todo);

      // 투두를 지우고, 마지막 또는 첫번째에 붙여넣기 합니다.
      _removeTodoById(id);
      _todoList?.insert(isChecked ? (_todoList?.length ?? 0) : 0, todo);

      if (isChecked) {
        // 완료 시 plant_cm 증가
        _plantCm += 1;

        // 이미지 표시 후 0.5초 후 사라지도록 설정
        _isCheckboxClicked = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _isCheckboxClicked = false;
          });
        });
      }
    });
  }

  /// 할 일 수정 함수 : 완료되지 않은 리스트를 클릭 시, 수정합니다.
  void _editTodoItem(TodoDBType todo) {
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
              onPressed: () async {
                final updatedTodo = todo.copy(title: titleController.text);
                await dbHelper.update(updatedTodo);

                setState(() {
                  final index = _todoList?.indexWhere((t) => t.id == todo.id);
                  if (index == null) return;

                  _todoList?[index] = updatedTodo;
                });

                // ignore: use_build_context_synchronously
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
    _plantCm = _todoList?.where((todo) => todo.isChecked).length ?? 0;

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
          itemCount: _todoList?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            final todo = _todoList?[index];
            if (todo == null) return null;

            final backgroundColor = todo.isChecked
                ? _themeColors.dismissedBackgroundColor
                : Colors.transparent;

            final textColor = _themeColors.textColor;

            return Dismissible(
                key: ValueKey<int>(todo.id),
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
                    todo.isChecked ? null : _editTodoItem(todo);
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
                          decoration: todo.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Checkbox(
                          value: todo.isChecked,
                          onChanged: (value) {
                            _onCheckboxChanged(todo.id, value ?? false);
                          },
                          activeColor: _themeColors.activeColor),
                      leading: Icon(
                        todo.isChecked ? Icons.check : Icons.hourglass_bottom,
                        color: todo.isChecked
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
            opacity: _isCheckboxClicked ? 0.0 : 1.0,
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
            opacity: _isCheckboxClicked ? 1.0 : 0.2,
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
