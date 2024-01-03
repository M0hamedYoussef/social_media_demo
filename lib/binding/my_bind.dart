import 'package:sm_project/controller/auth/login_con.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/download_controller.dart';
import 'package:sm_project/core/functions/check_connection.dart';
import 'package:get/get.dart';

class MyBind implements Bindings {
  @override
  void dependencies() {
    if (onlineCheck) {
      Get.put(LoginCon());
      Get.put(AppCon());
      Get.put(DownloadFiles());
    }
  }
}
