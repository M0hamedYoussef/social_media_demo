import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';

PreferredSizeWidget commentsAppBar() {
  return AppBar(
    backgroundColor: AppColors.white,
    title: const Text(
      'Comments',
      style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
    ),
    leading: GestureDetector(
      onTap: () {
        Get.back();
      },
      child: const Icon(
        Icons.arrow_back,
        color: AppColors.black,
      ),
    ),
  );
}
