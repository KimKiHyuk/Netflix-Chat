import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netflix_together/Page/AuthPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: AuthPage(),
      ),
    );
  }
}
