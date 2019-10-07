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
      print('error code : ' + exception.message);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.value.text,
        codeAutoRetrievalTimeout: autoRetrive,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiFailed);

    return '인증이 성공적으로 되었습니다';
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AuthenticationAlertComponent(_smsController, _trySigninWithCredential);
        });
  }

  Future<String> _trySigninWithCredential() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: _smsController.value.text);

      var user = await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (error) {
      print('error code is ' + error.code);
      return error.code;
    }

    return ''; //return String.empty()
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
                          hintText: '인증을 위해 휴대폰 번호를 입력해주세요.',
                          hintStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.smartphone, color: Colors.grey,),
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
                                if (_formKey.currentState.validate()) {
                                  await _login(context);
                                }
                              }))
                    ]))));
  }
}
