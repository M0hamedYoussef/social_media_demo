import 'package:social_media_demo/controller/posts/comments_con.dart';
import 'package:social_media_demo/view/widgets/posts/comments/app_bar.dart';
import 'package:social_media_demo/view/widgets/posts/comments/body/emojis.dart';
import 'package:social_media_demo/view/widgets/posts/comments/textform/full_row.dart';
import 'package:social_media_demo/view/widgets/posts/comments/body/stream.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CommentsCon commentsCon = Get.put(CommentsCon());

    return Scaffold(
      appBar: commentsAppBar(),
      body: Form(
        key: commentsCon.fst,
        child: Column(
          children: [
            const CommentsStream(),
            GetBuilder<CommentsCon>(
              builder: (con) => con.bottomWid,
            ),
            CommentsFormRow(
              focusNodeIcon: commentsCon.focusNodeIcon,
              posterNAME: commentsCon.posterNAME,
              posterUid: commentsCon.posterUid,
              posterTOKEN: commentsCon.posterTOKEN,
              postID: commentsCon.postID,
            ),
            CommentsEmoji(
              fst: commentsCon.fst,
              focusNodeIcon: commentsCon.focusNodeIcon,
            ),
          ],
        ),
      ),
    );
  }
}
