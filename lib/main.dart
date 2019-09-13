import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/FirebaseAPI/DataManipulator.dart';
import 'package:netflix_together/Page/Roomsearcher.dart';
import 'package:provider/provider.dart';
import 'package:netflix_together/Page/AuthPage.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:provider/provider.dart';

import 'Components/CurrentAppUserCounter.dart';
import 'Store/UserStore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: ApplicationEntry(),
        ));
  }
}


class ApplicationEntry extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.data == null) {   // TODO : change single proviers as multiple provider
          return ChangeNotifierProvider<LoginStore>.value(
              value: LoginStore(), child: AuthPage());
        } else {
          return ChangeNotifierProvider<UserStore>.value(
              value: UserStore(), child: RoomSearcher(email: snapshot.data.email));
        }
      },
    );
  }
}