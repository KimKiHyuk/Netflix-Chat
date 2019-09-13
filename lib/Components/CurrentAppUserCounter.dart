import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/FirebaseAPI/FirebaseWrapper.dart';
import 'package:netflix_together/FirebaseAPI/DataManipulator.dart';

class CurrentAppUserCounter extends StatefulWidget {
  @override
  Counter createState() => Counter();
}

class Counter extends State<CurrentAppUserCounter> {
  StreamSubscription _subscriptionPersona;
  StreamSubscription _streamSubscriptionOnlineUser;

  void initState() {
    FirebaseWrapper()
        .GetUserStream(
            "Users/online_user_num",
            (Event event) => {
                  setState(() {
                    User.onlineUserCount = event.snapshot.value;
                  })
                })
        .then((StreamSubscription s) => _streamSubscriptionOnlineUser = s);

    FirebaseWrapper()
        .GetUserStream("Users/id", (Event event) => {})
        .then((StreamSubscription s) => _subscriptionPersona = s);

    super.initState();
  }

  @override
  void dispose() {
    if (_subscriptionPersona != null) {
      _subscriptionPersona.cancel();
    }
    if (_streamSubscriptionOnlineUser != null) {
      _streamSubscriptionOnlineUser.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('현재 접속자 수 : ' + User.onlineUserCount.toString() + '명'),
    );
  }
}
