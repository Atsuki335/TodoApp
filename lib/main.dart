import 'package:flutter/material.dart';
import 'package:mytodoapp/todo_list_page.dart';

void main() {
  //最初に表示するwidget
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todoリスト',
      theme: ThemeData(
        //テーマカラー
        primarySwatch: Colors.blueGrey,
      ),
      //リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}
