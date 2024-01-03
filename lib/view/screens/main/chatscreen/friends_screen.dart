import 'package:sm_project/controller/chat/colors_controller.dart';
import 'package:sm_project/controller/chat/friends_con.dart';
import 'package:sm_project/view/widgets/chat/private_chats/app_bar.dart';
import 'package:sm_project/view/widgets/chat/private_chats/stream.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivateFriends extends StatelessWidget {
  const PrivateFriends({super.key});

  @override
  Widget build(BuildContext context) {
    FriendsCon friendsCon = Get.put(FriendsCon());
    Get.put(ColorsController());
    return GetBuilder<ColorsController>(
      builder: (cC) => Scaffold(
        appBar: privatesAppBar(),
        body: PrivatesStream(myUid: friendsCon.myUid),
      ),
    );
  }
}
