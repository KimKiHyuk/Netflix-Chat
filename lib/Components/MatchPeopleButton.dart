import 'package:flutter/material.dart';
import 'package:netflix_together/Components/LoadingAnimation.dart';

class MatchPeopleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      child: RaisedButton(
          child: SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.25,
              child: Center(
                child: Text(
                  '매칭',
                  textAlign: TextAlign.center,
                ),
              )),
          elevation: 5,
          color: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            print("button pressed");
          }),
    );
  }
}
