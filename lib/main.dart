import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netflix_together/Page/AuthPage.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider<LoginStore>.value(
            value: LoginStore(),
            child: Scaffold(
              body: AuthPage(),
            )));
  }
}
