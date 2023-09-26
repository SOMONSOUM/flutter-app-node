import 'package:flutter/material.dart';
import 'package:flutter_app_node/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user = User(
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

  User? get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
