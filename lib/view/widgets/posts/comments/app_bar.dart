import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSizeWidget commentsAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: const Text(
      'Comments',
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    leading: GestureDetector(
      onTap: () {
        Get.back();
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
  );
}
