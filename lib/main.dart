import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/FirebaseAPI/DataManipulator.dart';
import 'package:netflix_together/Page/Roomsearcher.dart';
import 'package:provider/provider.dart';
import 'package:netflix_together/Page/AuthPage.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:provider/provider.dart';

import 'Components/CurrentAppUserCounter.dart';
import 'Services/AccountService.dart';
import 'Store/UserStore.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

void main() {
  final injector = ModuleContainer().initialise(Injector.getInjector());

  //injector.get<SomeOtherType>(additionalParameters: {"id": "some-id"}); // prints 'some-id'
  runApp(MyApp());
}

class ModuleContainer {
  Injector initialise(Injector injector) {
    injector.map<AccountService>((i) => AccountService(), isSingleton: true);

    return injector;
  }
}

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
          Injector.getInjector().get<AccountService>().user = snapshot.data;
          if (snapshot.data == null) {
            // TODO : change single proviers as multiple provider
            return ChangeNotifierProvider<LoginStore>.value(
                value: LoginStore(), child: AuthPage());
          } else {

            return ChangeNotifierProvider<UserStore>.value(
                value: UserStore(), child: RoomSearcher());
          }
        });
  }
}
