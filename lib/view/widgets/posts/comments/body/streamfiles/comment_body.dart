import 'package:social_media_demo/models/comments_model.dart';
import 'package:social_media_demo/view/widgets/posts/comments/body/streamfiles/comment/comment_image.dart';
import 'package:social_media_demo/view/widgets/posts/comments/body/streamfiles/comment/comment_video.dart';
import 'package:flutter/material.dart';

class CommentBody extends StatelessWidget {
  const CommentBody({super.key, required this.commentsModel});

  final CommentsModel commentsModel;
  @override
  Widget build(BuildContext context) {
    return commentsModel.textOnly == false
        ? commentsModel.image == null
            ? commentsModel.textOnly == false
                ? CommentVideo(commentsModel: commentsModel)
                : const SizedBox()
            : CommentImage(commentsModel: commentsModel)
        : const SizedBox();
  }
}
