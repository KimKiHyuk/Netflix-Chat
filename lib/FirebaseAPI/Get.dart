import 'package:cloud_firestore/cloud_firestore.dart';

class Get {
  Get() {}

  bool GetCount() {
    Firestore.instance
        .collection('users')
        .document('lovelyz')
        .get()
        .then((DocumentSnapshot ds) {
          print(ds['online']);
          return ds['online'];
      // use ds as a snapshot
    });
  }
}
