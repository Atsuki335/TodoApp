import 'package:flutter/material.dart';

void main() {
  //最初に表示するwidget
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo App',
      theme: ThemeData(
        //テーマカラー
        primarySwatch: Colors.blue,
      ),
      //リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}

//リスト一覧画面用widget
class TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト一覧'),
      ),
      body: ListView(children: <Widget>[
        Card(child: ListTile(title: Text('ニンジンを買う'))),
        Card(child: ListTile(title: Text('タマネギを買う'))),
        Card(child: ListTile(title: Text('ジャガイモを買う'))),
        Card(child: ListTile(title: Text('カレールーを買う'))),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigatorをpushで新規画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              //遷移先の画面としてリスト追加画面を指定
              return TodoAddPage();
            }),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// リスト追加画面用Widget
class TodoAddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TextButton(
        onPressed: () {
          //”POP"で前の画面に戻る
          Navigator.of(context).pop();
        },
        child: Text('リスト追加画面（クリックで戻る) '),
      ),
    ));
  }
}
