import 'package:flutter/material.dart';
import 'package:netflix_together/Components/LoadingAnimation.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

class MatchPeopleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      child: Consumer<UserStore>(
        builder: (context, userStore, child) => RaisedButton(

          child: SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.25,
              child: Center(
                child: Text(
                  userStore.partyPeople == -1 ? '파티원 수를 선택해주세요' : userStore.partyPeople.toString() +  '명 매칭',
                  textAlign: TextAlign.center,
                ),
              )),
          elevation: 5,
          color: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: userStore.partyPeople == -1 ? null : () {
            // TO DO
          })),
    );
  }
}
