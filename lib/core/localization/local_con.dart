import 'package:sm_project/core/services/my_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  @override
  void onInit() {
    locale = myServices.mySharedPrefs.getString('lang') == null
        ? Get.deviceLocale
        : Locale(myServices.mySharedPrefs.getString('lang')!);
    super.onInit();
  }

  MyServices myServices = Get.find();
  Locale? locale;
  String? currentLang;

  change(String lang) {
    if (lang == 'Ar') {
      myServices.mySharedPrefs.setString('lang', 'ar');
      locale = const Locale('ar');
    } else {
      myServices.mySharedPrefs.setString('lang', 'en');
      locale = const Locale('en');
    }

    Get.updateLocale(Locale(myServices.mySharedPrefs.getString('lang')!));
  }
}
