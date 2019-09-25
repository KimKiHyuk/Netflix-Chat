import 'package:flutter/foundation.dart';


class UserStore extends ChangeNotifier {
  int _onlineUser;
  int _partyPeople;
  String _email;

  void Initalize() {
    _onlineUser = 0;
    _partyPeople = 4;
    _email = null;

    print('UserStore initalize done');
  }

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