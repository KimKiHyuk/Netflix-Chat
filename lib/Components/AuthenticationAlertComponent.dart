import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AuthenticationAlertComponent extends StatelessWidget {
  TextEditingController _smsController;
  Function callback;

  AuthenticationAlertComponent(this._smsController, this.callback) {}

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        title: Text('인증번호 입력'),
        content: TextFormField(
          controller: _smsController,
          decoration: InputDecoration(
              icon: Icon(Icons.lock), labelText: '인증번호를 입력해주세요'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.all(10.0),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              String _title = '인증 성공';
              String _message = '휴대폰 인증에 성공했습니다. 자동으로 로그인합니다.';
              String _signResult = await callback();
              if (_signResult == 'ok') {
                _title = '인증 성공';
                _message = '자동으로 로그인합니다.';
                Navigator.pop(context);
              }
              else if (_signResult == '') {
                _title = '인증 실패';
                _message = '인증 코드를 입력해주세요.';
                Navigator.pop(context);
              } else if (_signResult == 'ERROR_INVALID_VERIFICATION_CODE') {
                _title = '인증 실패';
                _message = '인증 코드가 틀렸습니다.';
              } else {
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
  }
}
