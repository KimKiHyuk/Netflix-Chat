import 'package:flutter/material.dart';
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
      child: Consumer<UserStore>(
        builder: (context, userStore, child) =>
            Text('현재 접속자 수는 : ' + userStore.OnlineUserCount.toString()),
      ),
    );
  }
}