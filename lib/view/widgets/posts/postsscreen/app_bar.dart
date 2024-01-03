import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sm_project/controller/chat/speed_dial_controller.dart';
import 'package:sm_project/core/services/my_services.dart';
import 'package:sm_project/routes.dart';
// import 'package:sm_project/view/screens/main/chatscreen/friends_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/view/screens/main/friends/friends.dart';
import 'package:sm_project/view/screens/main/posts/addpost.dart';

PreferredSizeWidget mainAppBar() {
  MyServices myServices = Get.find();
  SpeedDialController speedDialController = Get.put(SpeedDialController());

  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SpeedDial(
              direction: SpeedDialDirection.down,
              icon: Icons.table_rows_rounded,
              activeIcon: Icons.view_column_rounded,
              childPadding: const EdgeInsets.only(left: 15),
              activeBackgroundColor: AppColors.darkBlue1,
              openCloseDial: speedDialController.hidePostsScreen,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              buttonSize: const Size.fromRadius(20),
              overlayOpacity: 0.28,
              backgroundColor: AppColors.darkBlue,
              children: [
                SpeedDialChild(
                  child: InkWell(
                    onTap: () {
                      speedDialController.hidePostsScreen.value =
                          !speedDialController.hidePostsScreen.value;
                      Get.offNamed(AppRoutes.profile);
                    },
                    borderRadius: BorderRadius.circular(60),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.darkBlue1,
                      size: 30,
                    ),
                  ),
                ),
                SpeedDialChild(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: () {
                      speedDialController.hidePostsScreen.value =
                          !speedDialController.hidePostsScreen.value;
                      Get.off(
                        () => const AddPost(),
                        transition: Transition.downToUp,
                      );
                    },
                    child: const Icon(
                      Icons.post_add,
                      color: AppColors.darkBlue1,
                      size: 30,
                    ),
                  ),
                ),
                SpeedDialChild(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: () async {
                      speedDialController.hidePostsScreen.value =
                          !speedDialController.hidePostsScreen.value;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then(
                        (value) async {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                            {
                              'token': 'signed out',
                            },
                          );
                        },
                      );
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                      await myServices.mySharedPrefs.clear();
                      Get.offAllNamed(AppRoutes.sign);
                    },
                    child: const Icon(
                      Icons.logout,
                      color: AppColors.darkBlue1,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            const Text(
              'SMP',
              style: TextStyle(
                color: AppColors.darkBlue1,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Get.to(
              const FriendsScreen(),
              transition: Transition.upToDown,
            );
          },
          icon: const Icon(
            Icons.person_add,
            color: AppColors.darkBlue1,
          ),
        ),
      ],
    ),
    elevation: 0,
    backgroundColor: AppColors.white,
  );
}
