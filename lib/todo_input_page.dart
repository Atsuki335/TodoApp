import 'package:flutter/material.dart';
import 'todo_list_store.dart';
import 'todo.dart';

class TodoInputPage extends StatefulWidget {
  //Todoのモデル
  final Todo? todo;

//Todoを引数で受け取った場合は更新、受け取らない場合は追加画面になる
  const TodoInputPage({Key? key, this.todo}) : super(key: key);

  @override
  State<TodoInputPage> createState() => _TodoInputPageState();
}

class _TodoInputPageState extends State<TodoInputPage> {
  final TodoListStore _store = TodoListStore();

  late bool _isCreateTodo; //新規追加か

//以下画面項目
  late String _title;
  late bool _done; //完了か
  late String _createDate;
  late String _updateDate;

//初期処理を行う
  @override
  void initState() {
    super.initState();
    var todo = widget.todo;

    _title = todo?.title ?? "";
    _done = todo?.done ?? false;
    _createDate = todo?.createDate ?? "";
    _updateDate = todo?.updateDate ?? "";
    _isCreateTodo = todo == null;
  }

//画面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //どっちかを表示にするから両方書く
          title: Text(_isCreateTodo ? 'Todo追加' : 'Todo編集'),
        ),
        body: Container(
            padding: const EdgeInsets.all(30),
            child: Column(children: <Widget>[
              const SizedBox(height: 20),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: "やること",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
//setStateしなくても更新してくれる
                controller: TextEditingController(text: _title),
                onChanged: (String value) {
                  _title = value;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //late bool _isCreateTodo;　　でtrueなら追加(add)、falseなら編集(update)
                    if (_isCreateTodo) {
                      _store.add(_done, _title);
                    } else {
                      _store.update(widget.todo!, _done, _title);
                    }
                    Navigator.of(context).pop();

                    //編集画面でsnackBarが表示されるようにした
                    if (_isCreateTodo) {
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('編集しました'),
                        backgroundColor: Colors.grey,
                      ));
                    }
                  },
                  child: Text(
                    _isCreateTodo ? '追加' : '編集',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )),
              const SizedBox(height: 30),
              // 作成日時のテキストラベル
              Text("作成日時 : $_createDate"),
              // 更新日時のテキストラベル
              Text("更新日時 : $_updateDate"),
            ])));
  }
}
