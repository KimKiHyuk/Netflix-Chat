import 'package:flutter/material.dart';

class ProfileImageComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundImage: NetworkImage('https://i.pinimg.com/736x/85/23/90/85239064282010107df8e2989474b2ac.jpg'),
        radius: 140.0,

      )
    );
  }
}