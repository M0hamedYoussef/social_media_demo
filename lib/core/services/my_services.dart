import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_media_demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class MyServices extends GetxService {
  late SharedPreferences mySharedPrefs;
  Stream? oneStream;

  Future<MyServices> init() async {
    mySharedPrefs = await SharedPreferences.getInstance();
    await firebaseINIT();
    return this;
  }

  Future<MyServices> firebaseINIT() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance.subscribeToTopic('posts');
    return this;
  }
}

initService() async {
  await Get.putAsync(() => MyServices().init());
}
