import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/services/my_services.dart';

class ColorsController extends GetxController {
  MyServices myServices = Get.find();
  late Color savedChatColor;
  late Color savedAppBarColor;
  late Color savedFriendsColor;
  late Color savedFriendsAppBarColor;
  Color coloringIcon = Colors.transparent;

  @override
  void onInit() {
    savedChatColor =
        colorFromHex(myServices.mySharedPrefs.getString('chatColor') != null
                ? myServices.mySharedPrefs
                    .getString('chatColor')
                    .toString()
                    .substring(
                      6,
                      myServices.mySharedPrefs.getString('chatColor')!.length -
                          1,
                    )
                    .replaceRange(0, 4, '')
                    .trim()
                : 'FFFFFF') ??
            AppColors.white;
    savedAppBarColor =
        colorFromHex(myServices.mySharedPrefs.getString('appBarColor') != null
                ? myServices.mySharedPrefs
                    .getString('appBarColor')
                    .toString()
                    .substring(
                      6,
                      myServices.mySharedPrefs
                              .getString('appBarColor')!
                              .length -
                          1,
                    )
                    .replaceRange(0, 4, '')
                    .trim()
                : 'FFFFFF') ??
            AppColors.white;

    savedFriendsColor =
        colorFromHex(myServices.mySharedPrefs.getString('friendsColor') != null
                ? myServices.mySharedPrefs
                    .getString('friendsColor')
                    .toString()
                    .substring(
                      6,
                      myServices.mySharedPrefs
                              .getString('friendsColor')!
                              .length -
                          1,
                    )
                    .replaceRange(0, 4, '')
                    .trim()
                : 'FFFFFF') ??
            AppColors.white;
    savedFriendsAppBarColor = colorFromHex(
            myServices.mySharedPrefs.getString('friendsAppBarColor') != null
                ? myServices.mySharedPrefs
                    .getString('friendsAppBarColor')
                    .toString()
                    .substring(
                      6,
                      myServices.mySharedPrefs
                              .getString('friendsAppBarColor')!
                              .length -
                          1,
                    )
                    .replaceRange(0, 4, '')
                    .trim()
                : 'FFFFFF') ??
        AppColors.white;
    super.onInit();
  }

  chatColorSelected({required Color chatColor}) async {
    await myServices.mySharedPrefs.setString(
      'chatColor',
      chatColor.toString(),
    );
    savedChatColor = colorFromHex(myServices.mySharedPrefs
        .getString('chatColor')
        .toString()
        .substring(
          6,
          myServices.mySharedPrefs.getString('chatColor')!.length - 1,
        )
        .replaceRange(0, 4, '')
        .trim())!;

    update();
  }

  appBarColorSelected({required Color appBarColor}) async {
    await myServices.mySharedPrefs.setString(
      'appBarColor',
      appBarColor.toString(),
    );
    savedAppBarColor = colorFromHex(myServices.mySharedPrefs
        .getString('appBarColor')
        .toString()
        .substring(
          6,
          myServices.mySharedPrefs.getString('appBarColor')!.length - 1,
        )
        .replaceRange(0, 4, '')
        .trim())!;

    update();
  }

  friendsColorSelected({required Color friendsColor}) async {
    await myServices.mySharedPrefs.setString(
      'friendsColor',
      friendsColor.toString(),
    );
    savedFriendsColor = colorFromHex(myServices.mySharedPrefs
        .getString('friendsColor')
        .toString()
        .substring(
          6,
          myServices.mySharedPrefs.getString('friendsColor')!.length - 1,
        )
        .replaceRange(0, 4, '')
        .trim())!;

    update();
  }

  friendsAppBarColorSelected({required Color friendsAppBarColor}) async {
    await myServices.mySharedPrefs.setString(
      'friendsAppBarColor',
      friendsAppBarColor.toString(),
    );
    savedFriendsAppBarColor = colorFromHex(myServices.mySharedPrefs
        .getString('friendsAppBarColor')
        .toString()
        .substring(
          6,
          myServices.mySharedPrefs.getString('friendsAppBarColor')!.length - 1,
        )
        .replaceRange(0, 4, '')
        .trim())!;

    update();
  }

  Future<bool> coloringIconPop() {
    coloringIcon = Colors.transparent;
    update();
    Get.back();
    return Future.value(false);
  }

  barDialogOpened() {
    coloringIcon = AppColors.black;
    update();
  }
}
