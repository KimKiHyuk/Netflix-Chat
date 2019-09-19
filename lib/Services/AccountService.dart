import 'package:firebase_auth/firebase_auth.dart';

class AccountService {
  FirebaseUser user;

  AccountService() {
    print('init serv');
    FirebaseAuth.instance.onAuthStateChanged.listen((event) => {
          user = event,
        });
  }
}
