import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/FirebaseAPI/DataManipulator.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:netflix_together/validator/validator.dart';
import 'package:provider/provider.dart';

import 'AuthenticationAlertComponent.dart';

class LoginComponent extends StatelessWidget {
  final injector = Injector.getInjector();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // TODO : Dependency injecton
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String verificationId;
  String phoneNumber;
  String smsCode;

  Validator validator;

  LoginComponent() {
    validator = injector.get<Validator>();
  }

  Future<String> _login(BuildContext context) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print('verfied id is ' + this.verificationId);
      smsCodeDialog(context);
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
      print('verrfied ' + user.toString());
    };

    final PhoneVerificationFailed verifiFailed = (AuthException exception) {
      errorPhoneBar(context, exception);
    };

    FirebaseAuth.instance.setLanguageCode('kr');


    String _processed_phone = _phoneController.value.text;

    print(_processed_phone);
    if (_processed_phone.startsWith("+82")) {
      print('start with 82');
      print(_processed_phone);

    }

    if (_processed_phone.startsWith("0")) {
      print('start with 0');
      _processed_phone = _processed_phone.replaceFirst("0", "+82");
      print(_processed_phone);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _processed_phone,
        codeAutoRetrievalTimeout: autoRetrive,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiFailed);
    print('last pang');

    return '인증이 성공적으로 되었습니다';
  }

  void errorPhoneBar(BuildContext context, AuthException exception) {
    String _message;
    if (exception.code == 'invalidCredential' ||
        exception.code == 'verifyPhoneNumberError') {
      _message = '전화번호 양식이 틀렸습니다. 다음과 같이 입력해주세요: 010xxxxxxxx';
    } else {
      _message = '전화번호 입력 과정에서 알 수 없는 오류가 발생했습니다. 다시 시도해주세요.';
    }
    print('error cod2e : ' + exception.code);

    final snackBar = SnackBar(content: Text(_message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AuthenticationAlertComponent(
              _smsController, _trySigninWithCredential);
        });
  }

  Future<String> _trySigninWithCredential() async {
    try {

      if (_smsController.value.text.isEmpty) {
        return '';
      }

      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: _smsController.value.text);



      await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (error) {
      print('error code is ' + error.code);
      return error.code;
    }

    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;
    return Card(
        color: Colors.white30,
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
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintMaxLines: 2,
                          hintText: '인증을 위해 휴대폰 번호를 입력해주세요.',
                          hintStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.smartphone,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          alignment: Alignment(0.0, 0.0),
                          child: RaisedButton(
                              color: Colors.redAccent,
                              child: SizedBox(
                                width: size * 0.5,
                                child: Text(
                                  '인증번호 보내기',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () async {
                                if (_formKey.currentState.validate() &&
                                    validator.stringNullOrEmptyValadator(
                                        _phoneController.value.text)) {
                                  print('go login');
                                  await _login(context);
                                }
                              }))
                    ]))));
  }
}
