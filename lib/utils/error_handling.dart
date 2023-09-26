import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_node/utils/model_snackbar.dart';
import "package:http/http.dart" as http;

void httpErrorHandling({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;
    case 400:
    case 401:
    case 404:
    case 500:
      snackBarModel(
          context: context, message: jsonDecode(response.body)['message']);
      break;
    default:
      snackBarModel(context: context, message: response.body);
  }
}
