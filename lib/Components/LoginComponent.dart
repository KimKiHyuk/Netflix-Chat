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
      print('error code : ' + exception.code);
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
          return new AlertDialog(
              title: Text('인증번호 입력'),
              content: TextFormField(
                controller: _smsController,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock), labelText: '인증번호를 입력해주세요'),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.all(10.0),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    String _title = '인증 성공';
                    String _message = '휴대폰 인증에 성공했습니다. 자동으로 로그인합니다.';
                    String _signResult = await _trySigninWithCredential();
                    switch (_signResult) {
                      case '':
                        Navigator.pop(context);
                        break;
                      case 'ERROR_INVALID_VERIFICATION_CODE':
                        _title = '인증 실패';
                        _message = '인증 코드가 틀렸습니다.';
                        break;
                      default:
                        _title = '알 수 없는 오류';
                        _message = '인증과정에서 알 수 없는 오류가 발생했습니다. 다시 시도해주세요.';
                    }
                    Flushbar(
                      title: _title,
                      message: _message,
                      duration: Duration(seconds: 3),
                    )..show(context);
                    // await signIn();
                  },
                  child: Text('확인'),
                )
              ]);
        });
  }

  Future<String> _trySigninWithCredential() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: _smsController.value.text);

      var user = await FirebaseAuth.instance.signInWithCredential(credential);
      print('user is ' + user.toString());
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
                        controller: _phoneController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.smartphone),
                            labelText: '휴대폰 번호를 입력해주세요 (01012345678'),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          alignment: Alignment(0.0, 0.0),
                          child: RaisedButton(
                              color: Colors.cyan,
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
