import 'package:cloud_firestore/cloud_firestore.dart';

class Get {

  /* int GetOnlineUserCount() {
    Firestore.instance
        .collection('users')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print(f.data.keys == 'online' ));
    });
    return 1;
  }
  */


  Future<int> GetOnlineUserCount() async {
    int _onlineUserCount = -1;

    var network = await Firestore.instance.collection('users').where('online', isEqualTo: true).getDocuments();

    if (network != null) {
      _onlineUserCount = network.documents.length;
    }

    print(_onlineUserCount);
    return _onlineUserCount;
  }
}
