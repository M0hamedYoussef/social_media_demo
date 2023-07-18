import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/routes.dart';
import 'package:social_media_demo/view/screens/main/chatscreen/friends_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

PreferredSizeWidget postsAppBar() {
  MyServices myServices = Get.find();

  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                await myServices.mySharedPrefs.clear();
                Get.offAllNamed(AppRoutes.sign);
              },
              child: const Icon(
                Icons.logout,
                color: Colors.black,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Social App',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Get.to(
              () => const PrivateFriends(),
              transition: Transition.downToUp,
            );
          },
          icon: const Icon(
            Icons.chat,
            color: Colors.black,
          ),
        )
      ],
    ),
    backgroundColor: Colors.white,
  );
}
