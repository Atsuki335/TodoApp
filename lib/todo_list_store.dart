class TodoListStore {
  /// Todoリスト
  List<String> list = [];

  /// ストアのインスタンス
  static final TodoListStore _instance = TodoListStore._internal();

  /// プライベートコンストラクタ
  TodoListStore._internal();

  factory TodoListStore() {
    return _instance;
  }

  /// Todoを追加する
  void add(String todo) {
    list.add(todo);
  }

  void update(String todo, int index) {
    // listのindexで指定した要素をtodoに置き換える
    list[index] = todo;
  }
}
