import 'package:flutter/material.dart';

class ArrowUnderComponents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(children: <Widget>[
        Icon(Icons.keyboard_arrow_down, size: 30,),
        Icon(Icons.keyboard_arrow_down, size: 30,),
      ],),
      margin:
          EdgeInsets.only(top: size.height * 0.05, bottom: size.height * 0.05),
    );
  }
}
