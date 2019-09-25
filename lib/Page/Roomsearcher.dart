import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Components/ArrowToUnderComponents.dart';
import 'package:netflix_together/Components/CurrentAppUserCounter.dart';
import 'package:netflix_together/Components/LoadingAnimation.dart';
import 'package:netflix_together/Components/MatchPeopleButton.dart';
import 'package:netflix_together/Components/PeopleSelectorComponents.dart';

class RoomSearcher extends StatelessWidget {
  RoomSearcher({this.email});

  final injector = Injector.getInjector();
  final String email;

  void Initalize() {
    print('RoomSearcherPage initalize done');
  }

  @override
  Widget build(BuildContext context) {
    var _matchButton = MatchPeopleButton();
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back),
                  onPressed: () {
                  _matchButton.connectionClear();
                  FirebaseAuth.instance.signOut();
                },),
              ],),
          Center(child: Column(
            children: <Widget>[
              PeopleSelectorComponents(),
              ArrowUnderComponents(),
              _matchButton,
            ],
          ),)
          // TODO: when animation is activating, stop animation button is clicked again
        ]));
  }
}
