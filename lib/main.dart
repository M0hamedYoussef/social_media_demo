import 'package:sm_project/binding/my_bind.dart';
import 'package:sm_project/controller/global/notify_con.dart';
import 'package:sm_project/core/functions/check_connection.dart';
import 'package:sm_project/core/services/my_services.dart';
import 'package:sm_project/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

NotifyCon _noti = Get.put(NotifyCon());
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkInternet();
  await initService();
  if (onlineCheck) {
    await _noti.onMessageOpen();
  }
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
