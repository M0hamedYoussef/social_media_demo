import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/controller/global/notify_con.dart';
import 'package:sm_project/controller/posts/posts_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/view/screens/main/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSizeWidget addPostsBar() {
  PostsCon postsCon = Get.put(PostsCon());
  AppCon appCon = Get.find();
  String? myName = appCon.name;
  String? myPFP = appCon.pfp;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  LangCon langCon = Get.put(LangCon());
  NotifyCon notifyCon = Get.put(NotifyCon());
  return AppBar(
    backgroundColor: Colors.grey[200],
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          myName.toString(),
          style: const TextStyle(color: AppColors.black),
        ),
        IconButton(
          onPressed: () {
            if (postsCon.vidImg != const SizedBox()) {
              if (postsCon.initVAL.trim().isNotEmpty &&
                  postsCon.addImagePath == null &&
                  postsCon.pickedvid == null) {
                notifyCon.sendPostNotify(myName.toString(), myUid);
                postsCon.textPost(
                  myText: postsCon.initVAL.trim(),
                  myLang: langCon.langTextField,
                );
                postsCon.initVAL = '';
                postsCon.vidImg = const SizedBox();
                Get.back();
              } else if (postsCon.pickedimageUpload != null) {
                notifyCon.sendPostNotify(myName.toString(), myUid);

                postsCon.uploadImage(
                  myText: postsCon.initVAL.trim(),
                  myLang: langCon.langTextField ?? '',
                );
                postsCon.initVAL = '';
                postsCon.vidImg = const SizedBox();

                Get.back();
              } else if (postsCon.pickedvid != null) {
                notifyCon.sendPostNotify(myName.toString(), myUid);
                postsCon.uploadVid(
                  myText: postsCon.initVAL.trim(),
                  myLang: langCon.langTextField ?? '',
                );
                postsCon.initVAL = '';
                postsCon.vidImg = const SizedBox();
                Get.back();
              } else if (postsCon.initVAL.trim().isEmpty &&
                  postsCon.addImagePath == null &&
                  postsCon.pickedvid == null) {
                Get.defaultDialog(
                  title: 'Are You Sure Exiting Without Do Anything ?',
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.offAll(() => const MainScreen());
                        },
                        color: AppColors.black,
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 15),
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: AppColors.black,
                        child: const Text(
                          'No',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              if (postsCon.initVAL.trim().isNotEmpty &&
                  postsCon.addImagePath == null &&
                  postsCon.pickedvid == null) {
                notifyCon.sendPostNotify(myName.toString(), myUid);
                postsCon.textPost(
                  myText: postsCon.initVAL.trim(),
                  myLang: langCon.langTextField,
                );
                postsCon.initVAL = '';
                postsCon.vidImg = const SizedBox();
                Get.back();
              } else if (postsCon.initVAL.trim().isEmpty &&
                  postsCon.addImagePath == null &&
                  postsCon.pickedvid == null) {
                Get.defaultDialog(
                  title: 'Are You Sure Exiting Without Do Anything ?',
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.offAll(() => const MainScreen());
                        },
                        color: AppColors.black,
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 15),
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: AppColors.black,
                        child: const Text(
                          'No',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
          icon: const Icon(
            Icons.add,
            color: AppColors.black,
          ),
        ),
      ],
    ),
    leading: CircleAvatar(
      backgroundColor: AppColors.black,
      radius: 24,
      backgroundImage: NetworkImage(myPFP!),
    ),
  );
}
