import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Components/ProfileImageComponent.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfileImageComponent(),
            Stack(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(size.width * 0.06),
                child: LoginComponent(),
              ),
            ]),
          Container(
            child: Consumer<LoginStore>(
              builder: (context, loginStore, child) =>
                GestureDetector(
                  onTap: () {
                    loginStore.LoginJoinSwitch();
                  },
                  child: Text(loginStore.isJoin ? "If you don't have a account, just click this area to join" : 'If you have a account, just click this area to login'),
                ),
            )
          )],
        ),

      ),
    );
  }
}
