import 'package:get/get.dart';
import 'package:sm_project/view/screens/main/main/main_screen.dart';
import 'package:sm_project/view/widgets/posts/addscreen/added_media.dart';
import 'package:sm_project/view/widgets/posts/addscreen/app_bar.dart';
import 'package:sm_project/view/widgets/posts/addscreen/custom_listview.dart';
import 'package:sm_project/view/widgets/posts/addscreen/textform.dart';
import 'package:flutter/material.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: addPostsBar(),
      body: WillPopScope(
        onWillPop: () {
          Get.off(
            () => const MainScreen(),
            transition: Transition.size,
          );
          return Future.value(false);
        },
        child: const AddPostsListView(
          children: [
            AddPostsTextForm(),
            AddedMedia(),
          ],
        ),
      ),
    );
  }
}
