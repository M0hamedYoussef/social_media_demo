import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ObxCon extends GetxController {
  RxBool emoji = false.obs;
  TextEditingController mess = TextEditingController();
  FocusNode f = FocusNode();
  String? mtcheck = ''; //comments

  changeemojivis() {
    emoji.value = !emoji.value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    f.addListener(
      () {
        if (f.hasFocus) {
          emoji.value = false;
        }
      },
    );
  }

  @override
  void onClose() {
    mess.dispose();
    mtcheck = '';
    super.onClose();
  }
}
