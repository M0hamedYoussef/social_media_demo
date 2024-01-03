import 'package:sm_project/core/functions/check_connection.dart';
import 'package:sm_project/core/services/my_services.dart';
import 'package:sm_project/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMiddleware extends GetMiddleware {
  MyServices myServices = Get.find();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (onlineCheck) {
      if (myServices.mySharedPrefs.getBool('loged') == true) {
        return const RouteSettings(name: AppRoutes.main);
      }
    } else {
      return const RouteSettings(name: AppRoutes.offline);
    }
    return null;
  }
}
