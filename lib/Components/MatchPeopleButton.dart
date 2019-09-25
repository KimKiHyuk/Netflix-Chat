import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Components/LoadingAnimation.dart';
import 'package:netflix_together/FirebaseAPI/FirebaseWrapper.dart';
import 'package:netflix_together/Page/ChatRoom.dart';
import 'package:netflix_together/Services/AccountService.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

import 'LoginComponent.dart';

class MatchPeopleButton extends StatelessWidget {
  StreamSubscription _roomSubscription;
  FirebaseWrapper _firebaseRealtime;
  OnDisconnect _disconnectionSchedule;

  MatchPeopleButton() {
    print('compoents initalize');
    _roomSubscription = null;
    _firebaseRealtime = FirebaseWrapper();
    _disconnectionSchedule = null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final account = Injector.getInjector().get<AccountService>().user;
    return Container(
      child: Consumer<UserStore>(
        builder: (context, userStore, child) => RaisedButton(
            child: SizedBox(
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Center(
                  child: Icon(
                Icons.play_arrow,
                size: 30,
              )),
            ),
            shape: CircleBorder(),
            elevation: 10,
            color: Colors.amberAccent,
            onPressed: () async {
              Navigator.of(context).push(ModalAnimation()); // animation start
              String path = 'chat/room_' + userStore.partyPeople.toString();
              connectionClear();
              _firebaseRealtime.GetUserStream(
                  path,
                  (Event event) => {
                        if (event.snapshot.value[account.uid]['addr'] != null)
                          {
                            Navigator.pop(context), // to dispose modal
                            connectionClear(),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatRoom(path +
                                        '/' +
                                        event.snapshot.value[account.uid]
                                            ['addr'])))
                          }
                      }).then((StreamSubscription s) => _roomSubscription = s);

              await _disconnectionSchedule?.cancel();

              _disconnectionSchedule = FirebaseDatabase.instance
                  .reference()
                  .child(path + '/' + account.uid)
                  .onDisconnect();
              _disconnectionSchedule.remove();

              _firebaseRealtime.RegisterChatQueue(path + '/' + account.uid);
            }),
      ),
    );
  }

  void connectionClear() {
    _disconnectionSchedule?.cancel()?.then(
          (_) => _disconnectionSchedule = null,
        );

    _roomSubscription?.cancel()?.then((_) => {
          _roomSubscription = null,
          _firebaseRealtime.unRegisterChatQueue(),
        });
  }
}
