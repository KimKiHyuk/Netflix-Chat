import 'package:flutter/foundation.dart';


class UserStore extends ChangeNotifier {
  int _onlineUser = 0;
  int _partyPeople = -1;

  int get OnlineUserCount => _onlineUser;
  int get partyPeople => _partyPeople;

  void SetOnlineUserCount(int value) {
    _onlineUser = value;
    notifyListeners();
  }

  void SetPartyPeople(int value) {
    _partyPeople =  value;
    notifyListeners();
  }
}