import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Data/Message.dart';
import 'package:netflix_together/Page/ChatRoom.dart';
import 'package:netflix_together/Page/Roomsearcher.dart';

class MatchingNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  MatchingNotification(BuildContext context) {
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomSearcher()));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoom()));
      },
    );
  }
}

