import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoomSearcher extends StatelessWidget {
  RoomSearcher( {this.email} );
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FlatButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          }, child: Text(this.email))
        )
      )
    );
  }
}