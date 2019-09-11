import 'package:flutter/foundation.dart';


class UserStore extends ChangeNotifier {
  int _onlineUser = 0;

  int get OnlineUserCount => _onlineUser;

  void SetOnlineUserCount(int value) {
    _onlineUser = value;
    notifyListeners();
  }
}