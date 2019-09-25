import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Data/Message.dart';
import 'package:netflix_together/Page/ChatRoom.dart';
import 'package:netflix_together/Page/Roomsearcher.dart';

class ChatReadyNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void Initalize() {
    _firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> message) async {
          // TODO : when triggered app launched
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        }
    );

    print('ChatReadyNotification initalize done');
  }

  ChatReadyNotification() {}
}

