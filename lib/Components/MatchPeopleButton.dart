import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Components/LoadingAnimation.dart';
import 'package:netflix_together/FirebaseAPI/FirebaseWrapper.dart';
import 'package:netflix_together/Page/ChatRoom.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

import 'LoginComponent.dart';

class MatchPeopleButton extends StatelessWidget {
  StreamSubscription _roomSubscription;
  FirebaseWrapper _firebase_realtime = FirebaseWrapper();

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
                      userStore.partyPeople == -1
                          ? '파티원 수를 선택해주세요'
                          : userStore.partyPeople.toString() + '명 매칭',
                      textAlign: TextAlign.center,
                    ),
                  )),
              elevation: 5,
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: userStore.partyPeople == -1
                  ? null
                  : () {
                      if (_roomSubscription != null) {
                        // for building stream again
                        print(
                            '[1] room subscription does already exist. try subscription cancelation');
                        _roomSubscription.cancel();
                        _roomSubscription = null;
                      }
                      String path = 'room_' + userStore.partyPeople.toString();
                      _firebase_realtime.GetUserStream(
                          "chat/" + path,
                          (Event event) => {
                                print('chat Firebase status : ' +
                                    event.snapshot.value.toString()),
                                if (event.snapshot.value[LoginComponent.uid]
                                        ['addr'] !=
                                    null)
                                  {
                                    print('move to room! clear all asset'),
                                    _roomSubscription.cancel(),
                                    _roomSubscription = null,
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(path + '/' + event.snapshot.value[LoginComponent.uid]
                                            ['addr'], LoginComponent.static_user)))
                                  }
                              }).then(
                          (StreamSubscription s) => _roomSubscription = s);

                      _firebase_realtime.RegisterChatQueue(
                              LoginComponent.uid, path)
                          .catchError((error) => print(error));
                    })),
    );
  }
}
