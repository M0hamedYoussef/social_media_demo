import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/services/my_services.dart';

class ProfileController extends GetxController {
  AppCon appCon = Get.find();
  MyServices myServices = Get.find();
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  CollectionReference<Map<String, dynamic>> posts =
      FirebaseFirestore.instance.collection('posts');
  late String pfp;
  late String id;
  bool isUploading = false;
  TextEditingController name = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (appCon.pfp == null || appCon.name == null) {
      pfp = myServices.mySharedPrefs.getString('pfp')!;
      name.text = myServices.mySharedPrefs.getString('username')!;
    } else {
      pfp = appCon.pfp!;
      name.text = appCon.name!;
    }
    id = FirebaseAuth.instance.currentUser?.uid ?? 'No Data';
  }

  uploadNewPhoto() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    Reference? storageref;
    XFile? pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      isUploading = true;
      update();
      File image = File(pickedimage.path);
      storageref = FirebaseStorage.instance.ref('pfp/$userID');
      await storageref.putFile(image);
      String imageUrl = await storageref.getDownloadURL();
      isUploading = false;
      await users.where('UserID', isEqualTo: userID).get().then(
        (value) async {
          for (var element in value.docs) {
            String docid = element.reference.id;
            await users.doc(docid).update(
              {
                'pfp': imageUrl,
              },
            );
          }
        },
      );

      await myServices.mySharedPrefs.setString('pfp', imageUrl);
      pfp = imageUrl;
      appCon.pfp = imageUrl;
      update();
    }
  }

  changeName() async {
    if (name.text != appCon.name.toString() &&
        name.text.isNotEmpty &&
        name.text.length <= 14) {
      await users
          .where('UserID', isEqualTo: id)
          .get()
          .then(
            (value) async {
              for (var element in value.docs) {
                String docid = element.reference.id;
                await users.doc(docid).update(
                  {
                    'UserName': name.text.trim(),
                  },
                );
              }
            },
          )
          .then((value) => appCon.name = name.text.trim())
          .then(
            (value) async {
              await posts.where('UserID', isEqualTo: id).get().then(
                (value) async {
                  for (var element in value.docs) {
                    String docid = element.reference.id;
                    await posts.doc(docid).update(
                      {
                        'username': name.text.trim(),
                      },
                    );
                  }
                },
              );
            },
          );
      await myServices.mySharedPrefs.setString('username', name.text.trim());
      appCon.name = name.text.trim();
      Get.defaultDialog(
        title: 'Alert',
        middleText: 'Name Changed',
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.darkBlue1,
        ),
        middleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.darkBlue1,
        ),
      );
    } else {
      Get.defaultDialog(
        title: 'Alert',
        middleText: 'Name Cannot Be Empty Or Longer Than 14',
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.darkBlue1,
        ),
        middleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.darkBlue1,
        ),
      );
    }
  }
}
