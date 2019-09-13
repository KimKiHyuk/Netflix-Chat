class User {
  static int onlineUserCount = -1;
  final String _key;
  bool online = false; // for realtime db
  String timestamp = '0000';

  User.fromJson(this._key, Map data) {
    print('fromjson : ' + data.length.toString());

    online = data['online'];
    timestamp = data['timestamp'];

    // if (online == null) online = true;
    // if (timestamp == null) timestamp ="is null";
  }

}

class UserStatus {
  final bool online;
  final String timestamp;

  UserStatus({this.online, this.timestamp});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['online'] = this.online;
    map['timestamp'] = this.timestamp;

    return map;
  }
}
