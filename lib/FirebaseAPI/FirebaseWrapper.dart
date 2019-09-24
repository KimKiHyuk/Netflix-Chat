import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/Services/AccountService.dart';

class FirebaseWrapper {
  Future<StreamSubscription<Event>> GetUserStream(String key, void processData(Event event)) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child(key)
        .onValue
        .listen((Event event) {
          processData(event);
    });

    return subscription;
  }

  Future<void> RegisterChatQueue(String uid, String path) async {
    var message = Injector.getInjector().get<AccountService>().messaging;
    var tokenData  = await message.getToken();
    FirebaseDatabase.instance.reference().child(path).child(uid).set({
      'addr' : null,
      'token' : tokenData,
      'timestamp': DateTime.now().toString(), // should be server time, Todo : Firebase.servervalue.time
    });
  }

  Future<void> UnRegisterChatQueue(String uid, String path) async {
    FirebaseDatabase.instance.reference().child('chat').child(path)
        .child(uid)
        .remove().then((_) {
          print('[new] delete chat/$path/$uid success');
    });
  }



}