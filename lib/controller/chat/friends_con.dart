import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sm_project/models/friends_model.dart';

class FriendsCon extends GetxController {
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  LangCon langCon = Get.put(LangCon());
  TextEditingController searchCon = TextEditingController();
  FocusNode searchFocus = FocusNode();
  late DocumentReference<Map<String, dynamic>> myFriends;
  late String myUid;
  late Stream stream;
  List myFriendList = [];
  FriendeModel? friendModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    stream = users.snapshots();
    myUid = FirebaseAuth.instance.currentUser!.uid;
    myFriends = FirebaseFirestore.instance.collection('users').doc(myUid);

    getFriends();
  }

  getFriends() async {
    await myFriends.get().then(
      (value) {
        myFriendList = value.data()!['friends'];
        update();
      },
    );
  }

  searchCompleted() async {
    await users.where('UserName', isEqualTo: searchCon.text.trim()).get().then(
      (value) {
        for (var element in value.docs) {
          if (element.data()['UserID'] != myUid) {
            friendModel = FriendeModel.fromMap(element.data());
            update();
          }
        }
      },
    );
  }

  addFriend() async {
    await myFriends.get().then(
      (value) async {
        if (value.data() != null) {
          List currentFriends = value.data()!['friends'];
          if (!currentFriends.contains(friendModel!.userID.toString())) {
            currentFriends.add(friendModel!.userID.toString());
            await myFriends.update(
              {
                'friends': currentFriends,
              },
            );
            Fluttertoast.showToast(
              msg: 'Added',
              backgroundColor: AppColors.white,
              textColor: AppColors.black,
            );
            getFriends();
          } else {
            Fluttertoast.showToast(
              msg: 'Already Friend',
              backgroundColor: AppColors.white,
              textColor: AppColors.black,
            );
          }
        }
      },
    );
  }
}
