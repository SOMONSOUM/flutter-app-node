import 'package:flutter/material.dart';
import 'package:flutter_app_node/models/todo_model.dart';
import 'package:flutter_app_node/services/todo_method.dart';

class TodoProvider extends ChangeNotifier {
  final TodoResource todoResource = TodoResource();
  List<TodoModel> _todo = [];

  List<TodoModel> get todo => _todo;
  int get todoLength => todo.length;

  void getRefreshData(List<TodoModel> todo) {
    _todo = todo;
    notifyListeners();
  }

  void setRefreshData(TodoModel todo) {
    _todo.insert(0, todo);
    notifyListeners();
  }

  void editRefreshData({
    required int index,
    required String title,
    required String content,
  }) {
    _todo[index].title = title;
    _todo[index].content = content;
    notifyListeners();
  }

  void deleteRefreshData(TodoModel todo) {
    _todo.remove(todo);
    notifyListeners();
  }
}
