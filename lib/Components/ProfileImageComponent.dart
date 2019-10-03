import 'package:flutter/material.dart';

class ProfileImageComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Image.asset('lib/assets/images/netflix-chat-logo.png'),
    );
  }
}
