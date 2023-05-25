import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'todo_list_store.dart';
import 'todo_input_page.dart';
import 'todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
//Todoリストのデータ
  final TodoListStore _store = TodoListStore();

  void _pushTodoInputPage([Todo? todo]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TodoInputPage(todo: todo);
        },
      ),
    );

    setState(() {});
  }

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
            itemCount: _store.count(), //length リスト内の要素の数を変更する
            itemBuilder: (context, index) {
              var item = _store.findByIndex(index);
              return Slidable(
                  endActionPane: ActionPane(
                      extentRatio: 0.50, //スライド時に表示するwidgetの大きさ
                      motion: const ScrollMotion(), //スライドアニメーションの種類
                      children: [
                        SlidableAction(
                            onPressed: (context) {
                              _pushTodoInputPage(item);
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
                                                  _store.delete(item);
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
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      )),
                      child: Card(
                          child: ListTile(
                              title: Text(item.title),
                              trailing: Checkbox(
                                  value: item.done,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _store.update(item, value!);
                                    });
                                  })))));
            }),
        floatingActionButton: FloatingActionButton(
          //追加３　リスト追加画面からのデータを受け取る async~await,47
          onPressed: _pushTodoInputPage,
          child: Icon(Icons.add),
        ));
  }
}
