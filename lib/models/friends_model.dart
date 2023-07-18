import 'package:firebase_auth/firebase_auth.dart';

class FriendeModel {
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  Map? data;
  bool? thereIsLastDate;
  bool? thereIsLastMess;
  String? lastDate;
  String? lastMess;
  String? profilePicture;
  String? userID;
  String? userName;
  String? token;
  FriendeModel({
    this.data,
    this.thereIsLastDate,
    this.thereIsLastMess,
    this.lastDate,
    this.lastMess,
    this.profilePicture,
    this.userID,
    this.userName,
    this.token,
  });

  FriendeModel.fromMap(Map<String, dynamic> snapshot) {
    data = snapshot;
    lastDate = snapshot['lastdate'] != null
        ? snapshot['lastdate']['${snapshot['UserID']}$myUid']
        : null;
    lastMess = snapshot['lastmess'] != null
        ? snapshot['lastmess']['${snapshot['UserID']}$myUid']
        : null;
    profilePicture = snapshot['pfp'];
    userID = snapshot['UserID'];
    userName = snapshot['UserName'];
    token =  snapshot['token'];
    thereIsLastDate = snapshot.containsKey('lastdate')
        ? snapshot['lastdate']
                        .toString()
                        .contains('${snapshot['UserID']}$myUid') ==
                    true &&
                snapshot['lastdate']['${snapshot['UserID']}$myUid'] != null
            ? thereIsLastDate = true
            : false
        : thereIsLastDate = false;

    thereIsLastMess = snapshot.containsKey('lastmess')
        ? snapshot['lastmess']
                        .toString()
                        .contains('${snapshot['UserID']}$myUid') ==
                    true &&
                snapshot['lastmess']['${snapshot['UserID']}$myUid'] != null
            ? thereIsLastDate = true
            : false
        : thereIsLastDate = false;
  }
}
