import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_node/constants/constant.dart';
import 'package:flutter_app_node/models/todo_model.dart';
import 'package:flutter_app_node/providers/todo_provider.dart';
import 'package:flutter_app_node/providers/user_provider.dart';
import 'package:flutter_app_node/utils/error_handling.dart';
import 'package:flutter_app_node/utils/model_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String uri = '$url/dev/api/flutter/todo';

class TodoResource {
  Future postTodoData({
    required BuildContext context,
    required int userId,
    required String token,
    required String title,
    required String content,
  }) async {
    try {
      final TodoModel todo = TodoModel(
        id: 0,
        userId: userId,
        title: title,
        content: content,
        createdAt: '',
      );

      http.Response response = await http.post(
        Uri.parse(uri),
        body: todo.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token'
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          Provider.of<TodoProvider>(context, listen: false).setRefreshData(
              TodoModel.fromJson(
                  jsonEncode(jsonDecode(response.body)['data'])));
        },
      );

      return response;
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }

  Future fetchDataTodo({required BuildContext context}) async {
    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).user!.token;
      List<TodoModel> todo = [];

      http.Response response = await http.get(
        Uri.parse(uri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token'
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          for (int i = 0; i < (jsonDecode(response.body)['data']).length; i++) {
            todo.add(TodoModel.fromJson(
                jsonEncode(jsonDecode(response.body)['data'][i])));
          }
          Provider.of<TodoProvider>(context, listen: false)
              .getRefreshData(todo);
        },
      );
      return todo;
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }

  Future editTodoData({
    required BuildContext context,
    required String title,
    required String content,
    required int id,
    required int index,
  }) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');

      http.Response response = await http.put(
        Uri.parse("$uri/$id"),
        body: jsonEncode(<String, String>{
          "title": title,
          "content": content,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token'
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          Provider.of<TodoProvider>(context, listen: false).editRefreshData(
            index: index,
            title: title,
            content: content,
          );
        },
      );

      return response;
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }

  Future removeTodoData({
    required BuildContext context,
    required int id,
    required TodoModel todo,
  }) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');

      http.Response res = await http.delete(
        Uri.parse("$uri/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token'
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          Provider.of<TodoProvider>(context, listen: false)
              .deleteRefreshData(todo);
        },
      );

      return res;
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }
}
