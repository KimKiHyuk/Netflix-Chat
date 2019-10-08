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

  Future<void> _login(BuildContext context) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print('verfied id is ' + this.verificationId);
      smsCodeDialog(context);
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
      // When verification succeed
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      showErrorSnackBar(context, exception);
    };

    String _processedPhone = _phoneController.value.text;

    if (_processedPhone == '+15555215556' ||
        _processedPhone == '+15555215558' ||
        _processedPhone == '+15555215560' ||
        _processedPhone == '+15555215554') {
      print('test device');
    } else if (_processedPhone.startsWith("0")) {
      _processedPhone = _processedPhone.replaceFirst("0", "+82");
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _processedPhone,
        codeAutoRetrievalTimeout: autoRetrive,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiedFailed);
  }

  void showErrorSnackBar(BuildContext context, AuthException exception) {
    String _message;
    if (exception.code == 'invalidCredential') {
      _message = '전화번호 양식이 틀렸습니다. ->\n010xxxxxxxx\n010-xxxx-xxxx';
    } else if (exception.code == 'verifyPhoneNumberError') {
      _message = '잘못된 전화번호입니다.';
    } else {
      _message = '전화번호 입력 과정에서 알 수 없는 오류가 발생했습니다. 다시 시도해주세요.';
    }
    print('error code : ' + exception.code);

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
    final Size size = MediaQuery.of(context).size;
    return Card(
        color: Colors.white30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 6,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: size.height * 0.01, left: size.width * 0.02, right: size.width * 0.02, top: size.height * 0.01),
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
                          margin: EdgeInsets.only(top: size.height * 0.015),
                          alignment: Alignment(0.0, 0.0),
                          child: RaisedButton(
                              color: Colors.redAccent,
                              child: SizedBox(
                                width: size.width * 0.5,
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
