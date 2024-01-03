import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ObxCon extends GetxController {
  RxBool emoji = false.obs;
  TextEditingController mess = TextEditingController();
  FocusNode textFormFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    textFormFocus.addListener(
      () {
        if (textFormFocus.hasFocus) {
          emoji.value = false;
          mess.selection = TextSelection.fromPosition(
            TextPosition(offset: mess.text.length),
          );
        }
      },
    );
  }

  @override
  void onClose() {
    mess.dispose();
    super.onClose();
  }

  changeemojivis() {
    if (emoji.value) {
      textFormFocus.requestFocus();
    } else {
      textFormFocus.unfocus();
    }
    emoji.value = !emoji.value;
  }
}
