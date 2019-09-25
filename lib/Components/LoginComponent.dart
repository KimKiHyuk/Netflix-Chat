import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/FirebaseAPI/DataManipulator.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:netflix_together/validator/validator.dart';
import 'package:provider/provider.dart';

class LoginComponent extends StatelessWidget {
  final injector = Injector.getInjector();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // TODO : Dependency injecton
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Validator validator;

  LoginComponent() {
    validator = injector.get<Validator>();
  }


  Future<String> _registeration(BuildContext context) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.value.text,
              password: _passwordController.value.text);

    } on PlatformException catch (error) {
      print(error.code);
      switch(error.code) {
        case 'ERROR_INVALID_EMAIL':
          return '이메일 양식을 지켜주세요 (yourname@mail.net)';
        case 'ERROR_WEAK_PASSWORD':
          return '보안을 위해 비밀번호는 6자리 이상으로 입력해주세요';
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return '이미 등록된 메일입니다. 다른 메일을 입력해주세요';
        default:
          return error.message;
      }
    }

    return '가입에 성공했습니다. 자동으로 로그인합니다.';
  }

  Future<String> _login(BuildContext context) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.value.text,
              password: _passwordController.value.text);
    } on PlatformException catch (error) {
      print(error.code);
      switch(error.code) {
        case 'ERROR_INVALID_EMAIL':
          return '이메일 양식을 지켜주세요 (yourname@mail.net)';
        case 'ERROR_WEAK_PASSWORD':
          return '보안을 위해 비밀번호는 6자리 이상으로 입력해주세요';
        case 'ERROR_USER_NOT_FOUND':
          return '해당하는 이메일이 등록되어있지 않습니다. 가입 후 사용해주세요';
        case 'ERROR_WRONG_PASSWORD':
          return '비밀번호가 틀렸습니다.';
        default:
          return error.message;
      }
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
                child: Consumer<LoginStore>(
                    builder: (context, loginStore, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.email),
                                    labelText: loginStore.isJoin ? '사용하실 e-mail을 입력해주세요.' : '가입하신 e-mail을 입력해주세요'),
                                validator: validator.stringValadator,
                              ),
                              TextFormField(
                                  controller: _passwordController,

                                  decoration: InputDecoration(
                                      icon: Icon(Icons.lock),
                                      labelText: loginStore.isJoin ? '사용하실 비밀번호를 입력해주세요' : '가입하신 계정의 비밀번호를 입력해주세요'),
                                  validator: validator.stringValadator),
                              Container(
                                  margin: EdgeInsets.only(top: 15.0),
                                  alignment: Alignment(0.0, 0.0),
                                  child: Consumer<LoginStore>(
                                      builder: (context, loginStore, child) =>
                                          RaisedButton(
                                              color: loginStore.isJoin
                                                  ? Colors.cyanAccent
                                                  : Colors.cyan,
                                              child: SizedBox(
                                                width: size * 0.5,
                                                child: Text(
                                                  loginStore.isJoin
                                                      ? '가입하기'
                                                      : '로그인하기',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  var snackMessage = loginStore
                                                          .isJoin
                                                      ? await _registeration(
                                                          context)
                                                      : await _login(context);

                                                  final SnackBar snackBar =
                                                      SnackBar(
                                                    content: Text(snackMessage),
                                                    action: SnackBarAction(
                                                      label: '닫기',
                                                      onPressed: () {
                                                        // Some code to undo the change.
                                                      },
                                                    ),
                                                  );
                                                  Scaffold.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              })))
                            ])))));
  }
}
