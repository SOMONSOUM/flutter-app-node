import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_node/constants/constant.dart';
import 'package:flutter_app_node/models/user_model.dart';
import 'package:flutter_app_node/providers/todo_provider.dart';
import 'package:flutter_app_node/providers/user_provider.dart';
import 'package:flutter_app_node/utils/error_handling.dart';
import 'package:flutter_app_node/utils/model_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String uri = '$url/dev/api/flutter/user';

class AuthResource {
  Future authSignUp({
    required BuildContext context,
    required String name,
    required String email,
    required int phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final User user = User(
        id: 0,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
        role: 'user',
        isAdmin: false,
        isActive: true,
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse("$uri/register"),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () async {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonEncode(jsonDecode(res.body)['data']));
          final SharedPreferences preferences =
              await SharedPreferences.getInstance();
          preferences.setString('token', jsonDecode(res.body)['data']['token']);
        },
      );

      return res;
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }

  Future authSignIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/login"),
        body: jsonEncode(<String, String>{
          "email": email,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () async {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonEncode(jsonDecode(response.body)['data']));
          final SharedPreferences preferences =
              await SharedPreferences.getInstance();
          preferences.setString(
              'token', jsonDecode(response.body)['data']['token']);
        },
      );

      return response;
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }

  Future getUserDetail({required BuildContext context}) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString('token');

      if (token == null || token == '') {
        sharedPreferences.setString('token', '');
      } else {
        http.Response res = await http.get(
          Uri.parse("$uri/profile"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
            'Authorization': 'Bearer $token',
          },
        );

        httpErrorHandling(
          response: res,
          context: context,
          onSuccess: () {
            Provider.of<UserProvider>(context, listen: false)
                .setUser(jsonEncode(jsonDecode(res.body)['data']));
          },
        );
        return res;
      }
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }

  Future authLogOut({required BuildContext context}) async {
    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).user!.token;

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('token', '');

      http.Response res = await http.get(
        Uri.parse("$uri/logout"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
      );
      final User user = User(
        id: 0,
        name: '',
        email: '',
        phoneNumber: 0,
        password: '',
        confirmPassword: '',
        role: '',
        isAdmin: false,
        isActive: false,
        token: '',
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(user.toJson());
          Provider.of<TodoProvider>(context, listen: false).getRefreshData([]);
        },
      );

      return res;
    } catch (err) {
      snackBarModel(context: context, message: err.toString());
      return err;
    }
  }
}
