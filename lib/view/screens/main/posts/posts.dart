import 'package:social_media_demo/controller/posts/posts_con.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/view/screens/main/posts/addpost.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/app_bar.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());
    MyServices myServices = Get.find();
    myServices.oneStream = postsCon.posts
        .orderBy(
          'date',
          descending: true,
        )
        .snapshots();

    return Scaffold(
      appBar: postsAppBar(),
      body: const PostsStream(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => const AddPost(),
            transition: Transition.downToUp,
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.post_add),
      ),
    );
  }
}
