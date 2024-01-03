import 'package:sm_project/controller/posts/posts_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/const/decoration.dart';
import 'package:sm_project/models/post_model.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/post/post_handling.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/decoration/post_bottom_bar.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/post/post_text.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/decoration/post_upper_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsStream extends StatelessWidget {
  const PostsStream({super.key});

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());
    String myUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: postsCon.posts
          .orderBy(
            'date',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              PostModel postModel =
                  PostModel.fromMap(snapshot.data!.docs[index].data());
              postsCon.getCommentCount(postModel: postModel);
              postsCon.postManage(postModel: postModel);
              final dateFormated = postsCon.formatDate(postModel: postModel);

              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PostsUpperRow(
                      myUid: myUid,
                      dateFormated: dateFormated,
                      postModel: postModel,
                    ),
                    PostText(postModel: postModel),
                    PostHandling(postModel: postModel),
                    PostsBottomBar(myUid: myUid, postModel: postModel),
                    const Divider(thickness: 0.5),
                  ],
                ),
              );
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: AppDecoration().screenHeight / 15,
              width: AppDecoration().screenWidth / 15,
              child: const CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
          );
        }
        return const Text('');
      },
    );
  }
}
