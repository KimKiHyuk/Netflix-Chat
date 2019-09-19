import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/FirebaseAPI/DataManipulator.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:netflix_together/validator/validator.dart';
import 'package:provider/provider.dart';

class LoginComponent extends StatelessWidget {

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // TODO : Dependency injecton
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Validator validator = Validator(); // TODO : dependency injection
  final DataManipulator _dbCommit =
      DataManipulator(); // TODO : dependecy injectionm

  Future<String> _Registeration(BuildContext context) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.value.text,
              password: _passwordController.value.text);
      FirebaseUser user = result.user;

      if (user == null) {
        return '가입 과정에서 오류가 발생하였습니다. 다른 이메일을 입력해보세요';
      }

      _dbCommit.CreateUser(user.uid,
          UserStatus(online: true, timestamp: DateTime.now().toString()));
    } on PlatformException catch (error) {
      return error.message;
    }

    return '가입에 성공했습니다. 자동으로 로그인합니다.';
  }

  Future<String> _Login(BuildContext context) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.value.text,
              password: _passwordController.value.text);

      FirebaseUser user = result.user;

      if (user == null) {
        return '로그인 과정에서 오류가 발생하였습니다. 다시 시도해주세요';
      }

      _dbCommit.UpdateUser(user.uid,
          UserStatus(online: true, timestamp: DateTime.now().toString()));
    } on PlatformException catch (error) {
      return error.message;
    }

    return '로그인에 성공했습니다.';
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 6,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: 10.0, left: 12.0, right: 12.0, top: 12.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email), labelText: 'Email'),
                        validator: validator.stringValadator,
                      ),
                      TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.security),
                              labelText: 'Password'),
                          validator: validator.stringValadator),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          alignment: Alignment(0.0, 0.0),
                          child: Consumer<LoginStore>(
                              builder: (context, loginStore, child) =>
                                  RaisedButton(
                                      color: loginStore.isJoin
                                          ? Colors.blue
                                          : Colors.red,
                                      child: SizedBox(
                                        width: size * 0.5,
                                        child: Text(
                                          loginStore.isJoin ? 'Join' : 'Login',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          print("1515 pressed");
                                          var snackMessage = loginStore.isJoin
                                              ? await _Registeration(context)
                                              : await _Login(context);

                                          final SnackBar snackBar = SnackBar(
                                            content: Text(snackMessage),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      })))
                    ]))));
  }
}
