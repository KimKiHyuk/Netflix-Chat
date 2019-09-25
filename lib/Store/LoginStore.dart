import 'package:flutter/foundation.dart';


class LoginStore extends ChangeNotifier {
  bool _isJoin;

  void Initalize() {
    _isJoin = false;
    print('LoginStore initalize done');
  }

  bool get isJoin => _isJoin;

  void LoginJoinSwitch() {
    _isJoin = !_isJoin;
    notifyListeners();
  }
}