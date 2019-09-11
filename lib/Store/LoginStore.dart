import 'package:flutter/foundation.dart';


class LoginStore extends ChangeNotifier {
  bool _isJoin = false;

  bool get isJoin => _isJoin;

  void LoginJoinSwitch() {
    _isJoin = !_isJoin;
    notifyListeners();
  }
}