import 'package:flutter/material.dart';

class ArrowUnderComponents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(children: <Widget>[
        //Divider(thickness: 1, color: Colors.white, endIndent: size.width * 0.1, indent: size.width * 0.1,),
      ],),
      margin:
          EdgeInsets.only(top: size.height * 0.05, bottom: size.height * 0.05),
    );
  }
}
