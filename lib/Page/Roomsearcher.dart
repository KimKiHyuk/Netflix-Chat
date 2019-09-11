import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Components/ClickedMatchButtonAnimation.dart';
import 'package:netflix_together/Components/MatchPeopleButton.dart';
import 'package:netflix_together/Components/PeopleSelectorComponents.dart';

class RoomSearcher extends StatelessWidget {
  RoomSearcher( {this.email} );
  final String email;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PeopleSelectorComponents(),
          MatchPeopleButton(), // TODO: when animation is activating, stop animation button is clicked again
          ClickedMatchButtonAnimation(),
        ],
      )
    );
  }
}