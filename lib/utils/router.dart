import 'package:flutter/material.dart';
import 'package:flutter_app_node/screens/view/home_screen.dart';

Route<dynamic> generatedRoute(RouteSettings routeNames) {
  switch (routeNames.name) {
    case HomeScreen.route:
      return MaterialPageRoute(
        settings: routeNames,
        builder: (context) => const HomeScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen does not exist"),
          ),
        ),
      );
  }
}
