import 'package:social_media_demo/binding/my_bind.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_demo/controller/global/notify_con.dart';

NotifyCon _noti = Get.put(NotifyCon());

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initService();
  await _noti.onMessageOpen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBind(),
      initialRoute: AppRoutes.sign,
      getPages: appRoutes,
    );
  }
}
