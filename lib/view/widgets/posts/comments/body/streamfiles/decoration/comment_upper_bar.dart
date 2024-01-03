import 'package:sm_project/models/comments_model.dart';
import 'package:sm_project/view/widgets/posts/comments/advanced/comment_info.dart';
import 'package:sm_project/view/widgets/posts/comments/advanced/comment_options.dart';
import 'package:flutter/material.dart';

class CommentUpperBar extends StatelessWidget {
  const CommentUpperBar(
      {super.key,
      required this.commentsModel,
      required this.myUid,
      required this.dateFormated});
  final CommentsModel commentsModel;
  final String myUid;
  final String dateFormated;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommentInfoRow(
              pfp: commentsModel.profilePicture!,
              date: dateFormated,
              username: commentsModel.userName!,
            ),
            CommentOptions(
              data: commentsModel.data,
              myUid: myUid,
            ),
          ],
        ),
      ],
    );
  }
}
