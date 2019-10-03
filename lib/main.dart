import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:netflix_together/Components/LoginComponent.dart';
import 'package:netflix_together/Data/User.dart';
import 'package:netflix_together/FirebaseAPI/DataManipulator.dart';
import 'package:netflix_together/Notification/ChatReadyNotification.dart';
import 'package:netflix_together/Page/Roomsearcher.dart';
import 'package:netflix_together/validator/validator.dart';
import 'package:provider/provider.dart';
import 'package:netflix_together/Page/AuthPage.dart';
import 'package:netflix_together/Store/LoginStore.dart';
import 'package:provider/provider.dart';

import 'Components/CurrentAppUserCounter.dart';
import 'Components/MatchPeopleButton.dart';
import 'Page/ChatRoom.dart';
import 'Services/AccountService.dart';
import 'Store/UserStore.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

bool bootStrap(Injector injector) {
  try {
    injector.get<AccountService>().Initalize();
    injector.get<LoginStore>().Initalize();
    injector.get<UserStore>().Initalize();
    injector.get<RoomSearcher>().Initalize();
    injector.get<AuthPage>().Initalize();
    injector.get<Validator>().Initalize();
    injector.get<ChatReadyNotification>().Initalize();
  } on Error catch (e) {
    print(e);
    return false;
  }

  return true;
}

void main() {
  final injector = ModuleContainer().initialise(Injector.getInjector());
  if (bootStrap(injector)) {
    runApp(MainApp());
  } else {
    runApp(FailApp());
  }
}

class ModuleContainer {
  Injector initialise(Injector injector) {
    // Service
    injector.map<AccountService>((i) => AccountService(), isSingleton: true);

    // Store
    injector.map<LoginStore>((i) => LoginStore(), isSingleton: true);
    injector.map<UserStore>((i) => UserStore(), isSingleton: true);

    // Page
    injector.map<RoomSearcher>((i) => RoomSearcher(), isSingleton: true);
    injector.map<AuthPage>((i) => AuthPage(), isSingleton: true);

    // Notification
    injector.map<ChatReadyNotification>((i) => ChatReadyNotification(),
        isSingleton: true);

    // Validator
    injector.map<Validator>((i) => Validator(), isSingleton: true);

    return injector;
  }
}

class FailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        color: Colors.red,
      ),
    ));
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
        child: ApplicationEntry(),
      ),
      backgroundColor: Color.fromRGBO(64, 62, 62, 1),
    ));
  }
}

class ApplicationEntry extends StatelessWidget {
  final injector = Injector.getInjector();

  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          Injector.getInjector().get<AccountService>().user = snapshot.data;
          if (snapshot.data == null) {
            // TODO : change single proviers as multiple provider
            return ChangeNotifierProvider<LoginStore>.value(
                value: injector.get<LoginStore>(),
                child: injector.get<AuthPage>());
          } else {
            return ChangeNotifierProvider<UserStore>.value(
                value: injector.get<UserStore>(),
                child: injector.get<RoomSearcher>());
          }
        });
  }
}
