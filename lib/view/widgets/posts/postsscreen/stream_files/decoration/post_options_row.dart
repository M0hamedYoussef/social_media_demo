import 'package:social_media_demo/models/post_model.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream_files/decoration/options_row_files/delete_post.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream_files/decoration/options_row_files/edit_post.dart';
import 'package:flutter/material.dart';

class PostOptionsRow extends StatelessWidget {
  const PostOptionsRow({
    super.key,
    required this.myUid,
    required this.postModel,
  });
  final String myUid;
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        EditPost(
          myUid: myUid,
          postModel: postModel,
        ),
        DeletePost(
          myUid: myUid,
          postUserId: postModel.userID!,
          postId: postModel.docID,
          postStorageref: postModel.storageref,
          postStoragerefVid: postModel.storagerefVid,
          postStoragerefThumb: postModel.storagerefThumb,
        ),
      ],
    );
  }
}
