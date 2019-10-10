import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Services/AccountService.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  String path;
  String name;

  ChatRoom(this.path, this.name) {}

  @override
  _ChatState createState() => _ChatState(path, name);
}

class _ChatState extends State<ChatRoom> {
  final user = Injector.getInjector().get<AccountService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String path;
  String name;

  _ChatState(this.path, this.name) {}

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> chatSendingCallback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection(path).add({
        'text': messageController.text,
        'name': name,
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
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            path.substring(path.length - 1 - (7 - 1), path.length) + '번 방',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                              name: doc.data['name'],
                              text: doc.data['text'],
                              me: name == doc.data['name'],
                            ))
                        .toList();
                    messages.insert( // first message
                        0,
                        Message(
                            name: '운영자',
                            text:
                                '넷플릭스 챗을 이용해주셔서 감사합니다.\n넷플릭스 계정을 자유롭게 공유하시길 바랍니다.\n뒤로가기 버튼으로 채팅방을 나가시면 다시 들어올 수 없으니 주의하시길 바랍니다.',
                            me: false));

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
                  child: Row(children: <Widget>[
                Expanded(
                  flex: 6,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "메세지를 입력해주세요.",
                      border: const OutlineInputBorder(),
                    ),
                    controller: messageController,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.send),
                      onPressed: () => chatSendingCallback(),
                    )),
              ]))
            ])));
  }
}

class Message extends StatelessWidget {
  final String name;
  final String text;

  final bool me;

  const Message({Key key, this.name, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: !me
                ? Container(
                    margin: EdgeInsets.only(
                        top: size.height * 0.01,
                        bottom: size.height * 0.01,
                        left: size.width * 0.02),
                    child: Text(name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        top: size.height * 0.01,
                        bottom: size.height * 0.01,
                        right: size.width * 0.02),
                  ),
          ),
          Material(
            color: me ? Colors.yellow : Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: SelectableText(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}
