import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMiddleware extends GetMiddleware {
  MyServices myServices = Get.find();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (myServices.mySharedPrefs.getBool('loged') == true) {
      return const RouteSettings(name: AppRoutes.main);
    }
    return null;
  }
}
