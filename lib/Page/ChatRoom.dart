import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Services/AccountService.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  static const String id = "CHAT";
  String path;

  ChatRoom(this.path) {}

  @override
  _ChatState createState() => _ChatState(path);
}

class _ChatState extends State<ChatRoom> {
  final user = Injector.getInjector().get<AccountService>().user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String path;

  _ChatState(this.path) {}

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> chatSendingCallback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection(path).add({
        'text': messageController.text,
        'email': user.email,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Room - '),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.close),
        onPressed: () {
          print('back to select view');
          Navigator.of(context).pop();
        })
      ],),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(path) // TODO: refactor
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                    email: doc.data['email'],
                    text: doc.data['text'],
                    me: user.email == doc.data['email'],
                  ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
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
                    onPressed: chatSendingCallback,
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

class Message extends StatelessWidget {
  final String email;
  final String text;

  final bool me;

  const Message({Key key, this.email, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            email,
          ),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}