import "package:flutter/material.dart";
import 'package:flutter_app_node/screens/authentication/sign_in.dart';
import 'package:flutter_app_node/screens/authentication/sign_up.dart';

class IndexAuth extends StatefulWidget {
  const IndexAuth({Key? key}) : super(key: key);

  @override
  State<IndexAuth> createState() => _IndexAuthState();
}

class _IndexAuthState extends State<IndexAuth> {
  bool isSignUp = false;
  void setToggleForm() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSignUp) {
      return SignUpScreen(onToggle: setToggleForm);
    } else {
      return SignInScreen(onToggle: setToggleForm);
    }
  }
}
