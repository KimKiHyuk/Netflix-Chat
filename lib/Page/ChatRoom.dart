import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Components/LoginComponent.dart';

class ChatRoom extends StatefulWidget {
  static const String id = "CHAT";
  const ChatRoom({Key key}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatRoom> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Chat'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.close),
        onPressed: () {
          _auth.signOut();
        })
      ],),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child:Container(height: size.height - 100,
                width: size.width,
                color: Colors.blue,
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  RaisedButton(
                    child: Text("Send"),
                    onPressed: () {

                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}