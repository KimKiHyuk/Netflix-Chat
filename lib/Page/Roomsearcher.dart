import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Components/ArrowToUnderComponents.dart';
import 'package:netflix_together/Components/CurrentAppUserCounter.dart';
import 'package:netflix_together/Components/InputNameComponents.dart';
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
    final Size size = MediaQuery.of(context).size;
    var _matchButton = MatchPeopleButton();
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _matchButton.connectionClear();
                    FirebaseAuth.instance.signOut();
                  },
                ),
              )),
          Container(margin: EdgeInsets.only(top: size.height*0.2),),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                InputNameComponents(),
                ArrowUnderComponents(),
                PeopleSelectorComponents(),
                ArrowUnderComponents(),
              ],
            ),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: _matchButton,
          ))
        ]);
  }
}
