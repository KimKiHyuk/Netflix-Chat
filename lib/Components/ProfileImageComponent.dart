import 'package:flutter/material.dart';

class ProfileImageComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.2, bottom: size.height * 0.1),
      child: Image.asset('lib/assets/images/netflix-chat-logo.png'),
    );
  }
}
