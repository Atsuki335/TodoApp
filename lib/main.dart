import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mytodoapp/todo_list_store.dart';

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
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
//Todoリストのデータ
  List<String> todoList = TodoListStore().list;

  @override
  void initState() {
    super.initState();

    Future(
      () async {
        // ストアからTodoリストデータをロードし、画面を更新する
        setState(() => {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('リスト一覧'),
        ),
        body: ListView.builder(
            itemCount: todoList.length, //length リスト内の要素の数を変更する
            itemBuilder: (context, index) {
              return Slidable(
                  endActionPane: ActionPane(
                      extentRatio: 0.50, //スライド時に表示するwidgetの大きさ
                      motion: const ScrollMotion(), //スライドアニメーションの種類
                      children: [
                        SlidableAction(
                            onPressed: (context) async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return TodoEditPage(index: index);
                                }),
                              );
                              setState(() {});
                            },
                            backgroundColor: Colors.blue,
                            icon: Icons.mode_edit,
                            label: '編集'),
                        SlidableAction(
                            onPressed: (_) async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, StepState) {
                                      return AlertDialog(
                                          title: Text("このタスクを消去"),
                                          content: Text("本当に消しちゃう？"),
                                          actions: [
                                            TextButton(
                                              child: Text('キャンセル'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                setState(() {
                                                  todoList.removeAt(index);
                                                });
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text('削除しました')));
                                              },
                                            )
                                          ]);
                                    });
                                  });
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: '削除'),
                      ]),
                  child: Card(
                      child: ListTile(
                    title: Text(todoList[index]),
                  )));
            }),
        floatingActionButton: FloatingActionButton(
          //追加３　リスト追加画面からのデータを受け取る async~await,47
          onPressed: () async {
            final newListText = await
                //Navigatorをpushで新規画面に遷移
                Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                //遷移先の画面としてリスト追加画面を指定
                return TodoAddPage();
              }),
            );
            if (newListText != null) {
              //キャンセルした場合はnewListTextがnullとなるので注意
              setState(() {
                //リスト追加
                todoList.add(newListText);
              });
            }
          },

          child: Icon(Icons.add),
        ));
  }
}

// リスト追加画面用Widget
class TodoAddPage extends StatefulWidget {
  //statelessをstatefulに変えたことで増えたコード　５６〜６１
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  //入力されたテキストをデータとして持つ(StatefulとStateが必要)
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('リスト追加'),
        ),
        body: Container(
            //余白を作る
            padding: EdgeInsets.all(64),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //入力されたテキストをTextFieldの上に表示
                  Text(_text, style: TextStyle(color: Colors.blue)),
                  const SizedBox(height: 8),
                  TextField(
                    //追加
                    //入力されたテキストの値を受け取る(valueが入力されたテキスト)
                    onChanged: (String value) {
                      //データが変更したことを知らせる(画面を更新する)
                      setState(() {
                        //データを変更
                        _text = value;
                      });
                    },
                  ), //テキスト入力
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
//追加２　popの引数から前の画面にデータを渡す
                          Navigator.of(context).pop(_text);
                        },
                        //colorにエラーが出た。変更後コード　96~97
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue),
                        child: Text('リスト追加',
                            style: TextStyle(color: Colors.white))),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        //popで前の画面に戻る
                        Navigator.of(context).pop();
                      },
                      child: Text('キャンセル'),
                    ),
                  )
                ])));
  }
}

//編集画面用
class TodoEditPage extends StatefulWidget {
  final int? index;
  const TodoEditPage({Key? key, this.index}) : super(key: key);

  @override
  _TodoEditPageState createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  final TodoListStore _store = TodoListStore();
  final _controller = TextEditingController();

  String _text = '';
  @override
  void initState() {
    super.initState();
    final todo = _store.list[widget.index!];
    _controller.text = todo;
    _text = todo;
  }

  //入力されたテキストをデータとして持つ(StatefulとStateが必要)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('リスト編集'),
        ),
        body: Container(
            //余白を作る
            padding: EdgeInsets.all(64),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //入力されたテキストをTextFieldの上に表示
                  Text(_text, style: TextStyle(color: Colors.blue)),
                  const SizedBox(height: 8),
                  TextField(
                    //追加
                    //入力されたテキストの値を受け取る(valueが入力されたテキスト)
                    onChanged: (String value) {
                      //データが変更したことを知らせる(画面を更新する)
                      setState(() {
                        //データを変更
                        _text = value;
                      });
                    },
                    // TextFieldの初期値に_textを設定
                    controller: _controller,
                  ), //テキスト入力
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _store.update(
                            _text,
                            widget.index!,
                          );

//追加２　popの引数から前の画面にデータを渡す
                          Navigator.of(context).pop(_text);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('編集しました')));
                        },
                        //colorにエラーが出た。変更後コード　96~97
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue),
                        child: const Text('リスト編集',
                            style: TextStyle(color: Colors.white))),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        //popで前の画面に戻る
                        Navigator.of(context).pop();
                      },
                      child: Text('キャンセル'),
                    ),
                  )
                ])));
  }
}
