import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

PrivateChatsCon _privateChatsCon = Get.put(PrivateChatsCon());

class LifeCycle extends GetxController with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) {
      _privateChatsCon.setOutOfChat();
    } else {
      _privateChatsCon.setInCHAT();
    }
  }
}
