import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:netflix_together/Data/User.dart';

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
}