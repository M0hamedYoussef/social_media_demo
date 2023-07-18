import 'package:social_media_demo/controller/posts/posts_con.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/models/post_model.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream_files/post/post_handling.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream_files/decoration/post_bottom_bar.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream_files/post/post_text.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream_files/decoration/post_upper_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsStream extends StatelessWidget {
  const PostsStream({super.key});

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());
    MyServices myServices = Get.find();
    String myUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: myServices.oneStream,
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
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width / 15,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
        return const Text('');
      },
    );
  }
}
