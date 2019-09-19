import 'package:flutter/foundation.dart';


class UserStore extends ChangeNotifier {
  int _onlineUser = 0;
  int _partyPeople = -1;
  String _email = null;

  int get OnlineUserCount => _onlineUser;
  int get partyPeople => _partyPeople;
  String get email => _email;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void SetOnlineUserCount(int value) {
    _onlineUser = value;
    notifyListeners();
  }

  void SetPartyPeople(int value) {
    _partyPeople =  value;
    notifyListeners();
  }
}