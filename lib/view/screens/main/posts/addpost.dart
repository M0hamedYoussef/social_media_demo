import 'package:social_media_demo/view/widgets/posts/addscreen/added_media.dart';
import 'package:social_media_demo/view/widgets/posts/addscreen/app_bar.dart';
import 'package:social_media_demo/view/widgets/posts/addscreen/custom_listview.dart';
import 'package:social_media_demo/view/widgets/posts/addscreen/textform.dart';
import 'package:flutter/material.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: addPostsBar(),
      body: const AddPostsListView(
        children: [
          AddPostsTextForm(),
          AddedMedia(),
        ],
      ),
    );
  }
}
