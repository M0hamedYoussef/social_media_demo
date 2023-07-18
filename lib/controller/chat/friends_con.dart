import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendsCon extends GetxController {
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  LangCon langCon = Get.put(LangCon());
  late String myUid;
  late Stream stream;

  @override
  void onInit() {
    super.onInit();
    MyServices myServices = Get.find();
    myUid = FirebaseAuth.instance.currentUser!.uid;
    myServices.oneStream = users.snapshots();
    stream = myServices.oneStream!;
  }
}
