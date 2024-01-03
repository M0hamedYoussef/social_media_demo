import 'package:sm_project/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDecoration {
  double screenWidth = Get.size.width;
  double screenHeight = Get.size.height;

  static OutlineInputBorder otb = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: AppColors.grey),
  );
}

InputDecoration myinputDecoration(
    {required String label, required String hint, required Widget suffixIcon}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 27),
    border: AppDecoration.otb,
    enabledBorder: AppDecoration.otb,
    focusedBorder: AppDecoration.otb,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    label: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, color: AppColors.black),
      ),
    ),
    suffixIcon: suffixIcon,
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 15),
  );
}
