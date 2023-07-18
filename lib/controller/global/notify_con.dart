import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:social_media_demo/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

AppCon _appCon = Get.put(AppCon());

class NotifyCon extends GetxController {
  @override
  onInit() async {
    myToken = (await FirebaseMessaging.instance.getToken())!;
    super.onInit();
  }

  late String myToken;
  String serverToken = 'my_token';

  sendNotification({
    required String title,
    required String body,
    required String pfp,
    required String friendUid,
    required String friendName,
    required String token,
  }) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body.toString(),
            'title': title.toString(),
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'pfp': pfp,
            'name':
                '${friendName[0].capitalize}${friendName.substring(1, friendName.length)}',
            'PrivateName': friendName,
            'uid': friendUid,
            'private': 'true',
            'posts': 'false',
            'comments': 'false',
            'fromToken': myToken,
            'toToken': token,
          },
          'to': token
        },
      ),
    );
  }

  sendPostNotify(String name, String uid) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'New Post',
            'body':
                '${name[0].capitalize}${name.substring(1, name.length)} Added New Post !!',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'uid': uid,
            'posts': 'true',
            'private': 'false',
            'comments': 'false',
            'toToken': '',
          },
          'to': '/topics/posts'
        },
      ),
    );
  }

  sendLikeNotify(String name, String uid, String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'New Post',
            'body':
                '${name[0].capitalize}${name.substring(1, name.length)} Added New Post !!',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'uid': uid,
            'posts': 'true',
            'private': 'false',
            'comments': 'false',
            'likes': 'true',
            'dislikes': 'false',
          },
          'to': token
        },
      ),
    );
  }

  sendDisLikeNotify(String name, String uid, String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'New Post',
            'body':
                '${name[0].capitalize}${name.substring(1, name.length)} Added New Post !!',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'uid': uid,
            'posts': 'false',
            'private': 'false',
            'comments': 'false',
            'likes': 'false',
            'dislikes': 'true',
          },
          'to': token
        },
      ),
    );
  }

  sendCommentNotify(String postID, String commentUID, String name,
      String postername, String uid, String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'New Comment',
            'body':
                '${_appCon.name![0].capitalize}${_appCon.name!.substring(1, _appCon.name!.length)} Added Comment!!',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'uid': uid,
            'postID': postID,
            'commentUID': commentUID,
            'PosterName': postername,
            'PosterUid': uid,
            'PosterToken': token,
            'posts': 'false',
            'private': 'false',
            'comments': 'true',
            'me?': uid == FirebaseAuth.instance.currentUser!.uid
                ? 'true'
                : 'false',
            'toToken': '',
          },
          'to': token
        },
      ),
    );
  }

  onMessageOpen() async {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message.data['private'] == 'true') {
          _appCon.friendToken == message.data['fromToken']
              ? null
              : Get.snackbar(
                  '${message.notification!.title}',
                  '${message.notification!.body}',
                  onTap: (s) {
                    Get.toNamed(
                      AppRoutes.privateChat,
                      arguments: {
                        'friendName': message.data['PrivateName'],
                        'friendPFP': message.data['pfp'],
                        'friendUid': message.data['uid'],
                        'friendToken': message.data['fromToken'],
                      },
                    );
                  },
                  duration: const Duration(milliseconds: 1250),
                );
        } else if (message.data['posts'] == 'true') {
          message.data['uid'] == FirebaseAuth.instance.currentUser?.uid
              ? null
              : Get.snackbar(
                  '${message.notification!.title}',
                  '${message.notification!.body}',
                  onTap: (s) {
                    Get.toNamed(AppRoutes.main);
                  },
                );
        } else if (message.data['comments'] == 'true') {
          message.data['me?'] == 'true'
              ? null
              : Get.snackbar(
                  '${message.notification!.title}',
                  '${message.notification!.body}',
                  onTap: (s) {
                    Get.toNamed(
                      AppRoutes.comments,
                      arguments: {
                        'postID': message.data['postID'],
                        'posterNAME': message.data['PosterName'],
                        'posterTOKEN': message.data['PosterToken'],
                        'posterUid': message.data['PosterUid'],
                      },
                    );
                  },
                );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.data['private'] == 'true') {
          Get.toNamed(
            AppRoutes.privateChat,
            arguments: {
              'friendUid': message.data['uid'],
              'friendName': message.data['PrivateName'],
              'friendPFP': message.data['pfp'],
              'friendToken': message.data['fromToken'],
            },
          );
        } else if (message.data['comments'] == 'true') {
          Get.toNamed(
            AppRoutes.comments,
            arguments: {
              'postID': message.data['postID'],
              'posterNAME': message.data['PosterName'],
              'posterTOKEN': message.data['PosterToken'],
              'posterUid': message.data['PosterUid'],
            },
          );
        }
      },
    );
  }

  initMess() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data['private'] == 'true') {
        Get.toNamed(
          AppRoutes.privateChat,
          arguments: {
            'friendUid': initialMessage.data['uid'],
            'friendName': initialMessage.data['PrivateName'],
            'friendPFP': initialMessage.data['pfp'],
            'friendToken': initialMessage.data['fromToken'],
          },
        );
      } else if (initialMessage.data['comments'] == 'true') {
        Get.toNamed(
          AppRoutes.comments,
          arguments: {
            'postID': initialMessage.data['postID'],
            'posterNAME': initialMessage.data['PosterName'],
            'posterTOKEN': initialMessage.data['PosterToken'],
            'posterUid': initialMessage.data['PosterUid'],
          },
        );
      }
    }
  }
}
