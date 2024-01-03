import 'package:sm_project/controller/posts/comments_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/models/comments_model.dart';
import 'package:sm_project/view/widgets/posts/comments/body/streamfiles/comment/comment_text.dart';
import 'package:sm_project/view/widgets/posts/comments/body/streamfiles/comment_body.dart';
import 'package:sm_project/view/widgets/posts/comments/body/streamfiles/decoration/comment_bottom_bar.dart';
import 'package:sm_project/view/widgets/posts/comments/body/streamfiles/decoration/comment_upper_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsStream extends GetView<CommentsCon> {
  const CommentsStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                CommentsModel commentsModel =
                    CommentsModel.fromMap(snapshot.data!.docs[index].data());
                final dateFormated =
                    controller.formatDate(commentsModel: commentsModel);
                controller.manageComment(commentsModel: commentsModel);

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CommentUpperBar(
                        commentsModel: commentsModel,
                        myUid: controller.myUid,
                        dateFormated: dateFormated,
                      ),
                      CommentText(commentsModel: commentsModel),
                      CommentBody(commentsModel: commentsModel),
                      CommentBottomBar(
                        commentsModel: commentsModel,
                        myUid: controller.myUid,
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width / 15,
                child: const CircularProgressIndicator(
                  color: AppColors.white,
                ),
              ),
            );
          }
          return const Text('');
        },
      ),
    );
  }
}
