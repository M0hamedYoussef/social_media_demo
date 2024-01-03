import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/controller/profile/profile_controller.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/const/decoration.dart';
import 'package:sm_project/view/screens/main/friends/friends.dart';
import 'package:sm_project/view/screens/main/main/main_screen.dart';
import 'package:sm_project/view/screens/main/media/image/imagescreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Get.off(
            () => const MainScreen(),
            transition: Transition.size,
          );
          return Future.value(false);
        },
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(left: 8, right: 8),
            children: [
              SizedBox(
                height: AppDecoration().screenHeight * 0.04,
              ),
              Center(
                child: GetBuilder<ProfileController>(
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () {
                        if (!profileController.isUploading) {
                          int random = Random().nextInt(100);
                          Get.to(
                            () => ImageScreen(
                              url: profileController.pfp,
                              heroTag:
                                  profileController.pfp + random.toString(),
                            ),
                            transition: Transition.downToUp,
                          );
                        }
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: AppDecoration().screenHeight * 0.5,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: profileController.isUploading
                            ? const CircularProgressIndicator(
                                color: AppColors.darkBlue1,
                              )
                            : CachedNetworkImage(
                                imageUrl: profileController.pfp,
                              ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: AppDecoration().screenHeight * 0.05,
              ),
              InkWell(
                onTap: () {
                  profileController.uploadNewPhoto();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.darkBlue1,
                    ),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Upload A New Profile Picture',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.darkBlue1,
                          ),
                        ),
                        Icon(
                          Icons.upload,
                          color: AppColors.darkBlue1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDecoration().screenHeight * 0.02),
              TextFormField(
                controller: profileController.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.darkBlue1,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.darkBlue1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.darkBlue1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.darkBlue1),
                  ),
                  label: Text(
                    profileController.name.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.darkBlue1,
                    ),
                  ),
                  hintText: "Enter Your Name",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: AppColors.darkBlue1.withOpacity(0.5),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      profileController.changeName();
                    },
                    child: const Icon(
                      Icons.check,
                      color: AppColors.darkBlue1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppDecoration().screenHeight * 0.02,
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    const FriendsScreen(),
                    transition: Transition.upToDown,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.darkBlue1,
                    ),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Add Friends',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.darkBlue1,
                          ),
                        ),
                        Icon(
                          Icons.person_add,
                          color: AppColors.darkBlue1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
