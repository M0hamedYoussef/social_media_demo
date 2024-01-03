import 'package:sm_project/controller/posts/comments_con.dart';
import 'package:sm_project/models/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentBottomBar extends GetView<CommentsCon> {
  const CommentBottomBar(
      {super.key, required this.commentsModel, required this.myUid});
  final String myUid;
  final CommentsModel commentsModel;
  @override
  Widget build(BuildContext context) {
    bool isLiked = controller.likedHandling(commentsModel: commentsModel);
    bool isDisLiked = controller.dislikedHandling(commentsModel: commentsModel);
    return commentsModel.likes != null
        ? Row(
            children: [
              IconButton(
                onPressed: () {
                  if (commentsModel.isImgUploaded == true ||
                      commentsModel.isVidUploaded == true ||
                      commentsModel.textOnly == true) {
                    if (commentsModel.data!['liked$myUid'] == false) {
                      controller.likes(
                        commentsModel.docID!,
                        commentsModel.likes!,
                      );
                      controller.commRef.doc(commentsModel.docID!).update(
                        {'liked$myUid': true},
                      );

                      ///Dis
                      if (commentsModel.data!['disliked$myUid']) {
                        controller.commRef.doc(commentsModel.docID!).update(
                          {'disliked$myUid': false},
                        );
                        controller.disLikes(
                          commentsModel.docID!,
                          commentsModel.dislikes! - 2,
                        );
                      }
                    } else if (commentsModel.data!['liked$myUid'] == true) {
                      controller.likes(
                        commentsModel.docID!,
                        commentsModel.likes! - 2,
                      );
                      controller.commRef.doc(commentsModel.docID!).update(
                        {'liked$myUid': false},
                      );
                    }
                  }
                },
                icon: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: isLiked
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_outline),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 19.5, 0, 0),
                        child: Text(
                          commentsModel.likes!.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (commentsModel.isImgUploaded == true ||
                      commentsModel.isVidUploaded == true ||
                      commentsModel.textOnly == true) {
                    if (commentsModel.data!['disliked$myUid'] == false) {
                      controller.disLikes(
                        commentsModel.docID!,
                        commentsModel.dislikes!,
                      );
                      controller.commRef.doc(commentsModel.docID!).update(
                        {'disliked$myUid': true},
                      );

                      ///likes mangment
                      if (commentsModel.data!['liked$myUid']) {
                        controller.commRef.doc(commentsModel.docID!).update(
                          {'liked$myUid': false},
                        );
                        controller.likes(
                          commentsModel.docID!,
                          commentsModel.likes! - 2,
                        );
                      }
                    } else if (commentsModel.data!['disliked$myUid'] == true) {
                      controller.disLikes(
                        commentsModel.docID!,
                        commentsModel.dislikes! - 2,
                      );
                      controller.commRef.doc(commentsModel.docID!).update(
                        {'disliked$myUid': false},
                      );
                    }
                  }
                },
                icon: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: isDisLiked
                            ? const Icon(Icons.heart_broken)
                            : const Icon(Icons.heart_broken_outlined),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 19.5, 0, 0),
                        child: Text(
                          commentsModel.dislikes!.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
