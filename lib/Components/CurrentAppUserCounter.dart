import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/FirebaseAPI/Get.dart';
import 'package:netflix_together/Store/UserStore.dart';
import 'package:provider/provider.dart';

class CurrentAppUserCounter extends StatefulWidget {

  @override
  State createState() => Counter();
}

class Counter extends State<CurrentAppUserCounter> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(future: Get().GetOnlineUserCount(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Text('현재 접속 유저 수 : ' + snapshot.data.toString());
        }),
      );
  }
}
