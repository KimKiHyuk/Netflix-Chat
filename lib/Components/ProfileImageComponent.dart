import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileImageComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.5,
      height: size.height * 0.3,
      margin: EdgeInsets.only(top: size.height * 0.1, bottom: size.height * 0.1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('lib/assets/images/netflix-chat-logo.png'),
        )
      ),
    );
  }
}
