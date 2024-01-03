import 'package:sm_project/controller/chat/friends_con.dart';
import 'package:sm_project/controller/posts/posts_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/view/widgets/chat/private_chats/stream.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/app_bar.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());
    Get.put(FriendsCon());

    return Scaffold(
      appBar: mainAppBar(),
      backgroundColor: AppColors.white,
      body: PageView(
        physics: const BouncingScrollPhysics(),
        children: [
          const PostsStream(),
          PrivatesStream(myUid: postsCon.myUid),
        ],
      ),
    );
  }
}
