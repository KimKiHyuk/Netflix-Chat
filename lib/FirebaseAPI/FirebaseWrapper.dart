import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/Services/AccountService.dart';

class FirebaseWrapper {
  Queue<String> _registeredRoom;

  FirebaseWrapper() {
    _registeredRoom = Queue<String>();
  }

  // TODO : rename needs

  Future<StreamSubscription<Event>> GetUserStream(
      String key, void processData(Event event)) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child(key)
        .onValue
        .listen((Event event) {
      try {
        processData(event);
      } on Error catch (e) {}
    });

    return subscription;
  }

  Future<void> RegisterChatQueue(String path) async {
    var message = Injector.getInjector().get<AccountService>().messaging;
    var tokenData = await message.getToken();
    FirebaseDatabase.instance.reference().child(path).set({
      'addr': null,
      'token': tokenData,
      'timestamp': DateTime.now().toString(),
      // should be server time, Todo : Firebase.servervalue.time
    });

    _registeredRoom?.addLast(path);
  }

  Future<void> unRegisterChatQueue() async {
    _registeredRoom.forEach((path) => {
          FirebaseDatabase.instance.reference().child(path).remove(),
        });

    _registeredRoom?.clear();
  }
}
