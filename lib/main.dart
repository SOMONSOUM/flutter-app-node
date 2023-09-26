import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_app_node/providers/todo_provider.dart';
import 'package:flutter_app_node/providers/user_provider.dart';
import 'package:flutter_app_node/screens/default_screen.dart';
import 'package:flutter_app_node/utils/router.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => generatedRoute(settings),
        home: const DefaultScreen(),
      ),
    );
  }
}
