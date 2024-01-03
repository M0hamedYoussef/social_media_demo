import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:sm_project/controller/chat/colors_controller.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/const/image_asset.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget privatesAppBar() {
  ColorsController colorsController = Get.put(ColorsController());

  return AppBar(
    backgroundColor: colorsController.savedFriendsAppBarColor,
    actions: [
      IconButton(
        onPressed: () {
          colorsController.barDialogOpened();
          Get.defaultDialog(
            title: 'Select Color',
            onWillPop: colorsController.coloringIconPop,
            content: ColorPicker(
              pickerAreaHeightPercent: 0.7,
              hexInputBar: true,
              pickerColor: colorsController.savedFriendsAppBarColor,
              onColorChanged: (color) {
                colorsController.friendsAppBarColorSelected(
                  friendsAppBarColor: color,
                );
              },
            ),
          );
        },
        icon: const Icon(Icons.color_lens),
        color: colorsController.coloringIcon,
      )
    ],
    leading: const CircleAvatar(
      backgroundImage: AssetImage(AppImageAsset.appLogo),
      backgroundColor: Colors.transparent,
      radius: 5,
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Text(
              'Chats',
              style: TextStyle(
                color: AppColors.darkBlue1,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
