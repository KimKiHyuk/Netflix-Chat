import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:netflix_together/Components/LoginComponent.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(color: Colors.green),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              color: Colors.blue,
            ),
            Stack(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: LoginComponent(),
              ),
            ]),
          ],
        ),
      ],
    ));
  }
}
