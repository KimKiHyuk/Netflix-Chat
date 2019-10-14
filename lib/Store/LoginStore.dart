import 'package:flutter/foundation.dart';


class LoginStore extends ChangeNotifier {
  bool _isSend;

  void Initalize() {
    _isSend = false;
    print('LoginStore initalize done');
  }

  bool get isSend => _isSend;

  void sendButtonSwitch() {
    _isSend = !_isSend;
    notifyListeners();
  }
}