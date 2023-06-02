import 'todo.dart';
import 'package:intl/intl.dart';

class TodoListStore {
  /// Todoリスト
  List<Todo> _list = []; //空のインスタンスを生成

  /// ストアのインスタンス インスタンス(クラスをベースに実体化されたもの)
  /// class:Todoの設計図、やる内容(Todoの文字列型) instance:Todoの中身（内容)
  static final TodoListStore _instance = TodoListStore._internal();

  /// プライベートコンストラクタ
  /// コンストラクタ名のの前にある_によりプライベートになる
  TodoListStore._internal();

// factoryコンストラクタ
  factory TodoListStore() {
    return _instance;
  }

  /// Todoの件数を取得する
  int count() {
    return _list.length;
  }

  /// 指定したインデックスのTodoを取得する
  Todo findByIndex(int index) {
    return _list[index];
  }

  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  /// Todoを追加する
  void add(bool done, String title) {
    var dateTime = getDateTime();
    var todo = Todo(title, done, dateTime, dateTime);
    _list.add(todo);
  }

  /// Todoを更新する
  void update(Todo todo, bool done, [String? title]) {
    todo.done = done;
    if (title != null) {
      todo.title = title;
    }
    todo.updateDate = getDateTime();
  }

  /// Todoを削除する
  void delete(Todo todo) {
    _list.remove(todo);
  }
}
