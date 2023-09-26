import "package:flutter/material.dart";
import 'package:flutter_app_node/models/user_model.dart';
import 'package:flutter_app_node/providers/user_provider.dart';
import 'package:flutter_app_node/screens/authentication/index.dart';
import 'package:flutter_app_node/screens/view/home_screen.dart';
import 'package:flutter_app_node/services/auth_method.dart';
import 'package:provider/provider.dart';

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  final AuthResource authResource = AuthResource();

  @override
  void initState() {
    super.initState();
    authResource.getUserDetail(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: user!.token.isEmpty ? const IndexAuth() : const HomeScreen(),
    );
  }
}
