import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AccountService {
  FirebaseUser user;
  FirebaseMessaging messaging;

  AccountService() {

  }

  void Initalize() {
    messaging = FirebaseMessaging();
    print('Account Service initalize done');
  }

}
