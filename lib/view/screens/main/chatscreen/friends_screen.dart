import 'package:social_media_demo/controller/chat/friends_con.dart';
import 'package:social_media_demo/view/widgets/chat/private_chats/app_bar.dart';
import 'package:social_media_demo/view/widgets/chat/private_chats/stream.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivateFriends extends StatelessWidget {
  const PrivateFriends({super.key});

  @override
  Widget build(BuildContext context) {
    FriendsCon friendsCon = Get.put(FriendsCon());
    return Scaffold(
      appBar: privatesAppBar(),
      body: WillPopScope(
        onWillPop: () {
          Get.back();
          return Future.value(false);
        },
        child: PrivatesStream(myUid: friendsCon.myUid),
      ),
    );
  }
}
