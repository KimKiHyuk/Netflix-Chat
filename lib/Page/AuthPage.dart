import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Components/ProfileImageComponent.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {

  void Initalize() {
    print('AuthPage initalize done');
  }


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
                  child: Text(loginStore.isJoin ? '계정이 있으신가요? 여기를 터치하여 로그인하세요' : '계정이 없으신가요? 여기를 터치하여 계정을 만들어보세요'),
                ),
            )
          )],
        ),

      ),
    );
  }
}
