import 'package:social_media_demo/controller/auth/login_con.dart';
import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:get/get.dart';

class MyBind implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginCon());
    Get.put(AppCon());
  }
}
