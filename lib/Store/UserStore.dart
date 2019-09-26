import 'package:flutter/foundation.dart';


class UserStore extends ChangeNotifier {
  int _onlineUser;
  int _partyPeople;
  String _name;

  void Initalize() {
    _onlineUser = 0;
    _partyPeople = 4;
    _name = 'default';
    print('UserStore initalize done');
  }

  int get OnlineUserCount => _onlineUser;
  int get partyPeople => _partyPeople;
  String get name => _name;

  void SetOnlineUserCount(int value) {
    _onlineUser = value;
    notifyListeners();
  }

  void SetPartyPeople(int value) {
    _partyPeople =  value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }
}