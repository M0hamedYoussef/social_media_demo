import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';

late bool onlineCheck;

Future<bool> checkInternet() async {
  try {
    List<InternetAddress> ping = await InternetAddress.lookup('www.google.com');
    if (ping.isNotEmpty && ping[0].rawAddress.isNotEmpty) {
      onlineCheck = true;
    }
  } on SocketException catch (_) {
    onlineCheck = false;
  }
  return onlineCheck;
}

noConnection() {
  Get.defaultDialog(
    title: 'Alert',
    middleText: 'No Internet',
    middleTextStyle: const TextStyle(
      color: AppColors.darkBlue1,
    ),
    titleStyle: const TextStyle(
      color: AppColors.darkBlue1,
    ),
  );
}
