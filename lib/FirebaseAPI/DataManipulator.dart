import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netflix_together/Data/User.dart';

class DataManipulator {
  Future<UserStatus> CreateUser(String uid, UserStatus status) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(Firestore.instance.collection('users').document(uid));

      var dataMap = status.toMap();
      await tx.set(ds.reference, dataMap);

      return dataMap;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      print('push data : ' + mapData.values.toString());
    }).catchError((onError) {
      print('push data error : ' + onError);
      return null;
    });
  }

  Future<dynamic> UpdateUser(String uid, UserStatus status) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(Firestore.instance.collection('users').document(uid));

      await tx.update(ds.reference, status.toMap());
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
}
