import 'package:sm_project/controller/posts/posts_con.dart';
import 'package:sm_project/models/post_model.dart';
import 'package:sm_project/view/screens/main/posts/comments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsBottomBar extends GetView<PostsCon> {
  const PostsBottomBar(
      {super.key, required this.myUid, required this.postModel});
  final String myUid;
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    bool isLiked = controller.likedHandling(postModel: postModel);
    bool isDisLiked = controller.dislikedHandling(postModel: postModel);
    return postModel.likes != null
        ? Row(
            children: [
              IconButton(
                onPressed: () {
                  if (postModel.isImgUploaded == true ||
                      postModel.isVidUploaded == true ||
                      postModel.textOnly == true) {
                    if (postModel.data!['liked$myUid'] == false) {
                      controller.likes(
                        postModel.docID!,
                        postModel.likes!,
                      );
                      controller.posts.doc(postModel.docID!).update(
                        {'liked$myUid': true},
                      );

                      if (postModel.data!['disliked$myUid']) {
                        controller.posts.doc(postModel.docID!).update(
                          {'disliked$myUid': false},
                        );
                        controller.disLikes(
                          postModel.docID!,
                          postModel.dislikes! - 2,
                        );
                      }
                    } else if (postModel.data!['liked$myUid'] == true) {
                      controller.likes(
                        postModel.docID!,
                        postModel.likes! - 2,
                      );
                      controller.posts.doc(postModel.docID!).update(
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
                        child: isLiked
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_outline),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 19, 0, 0),
                        child: Text(
                          postModel.likes!.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (postModel.isImgUploaded == true ||
                      postModel.isVidUploaded == true ||
                      postModel.textOnly == true) {
                    if (postModel.data!['disliked$myUid'] == false) {
                      controller.disLikes(
                        postModel.docID!,
                        postModel.dislikes!,
                      );
                      controller.posts.doc(postModel.docID!).update(
                        {'disliked$myUid': true},
                      );

                      ///likes mangment
                      if (postModel.data!['liked$myUid']) {
                        controller.posts.doc(postModel.docID!).update(
                          {'liked$myUid': false},
                        );
                        controller.likes(
                          postModel.docID!,
                          postModel.likes! - 2,
                        );
                      }
                    } else if (postModel.data!['disliked$myUid'] == true) {
                      controller.disLikes(
                        postModel.docID!,
                        postModel.dislikes! - 2,
                      );
                      controller.posts.doc(postModel.docID!).update(
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
                        child: isDisLiked
                            ? const Icon(Icons.heart_broken)
                            : const Icon(Icons.heart_broken_outlined),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 19, 0, 0),
                        child: Text(
                          postModel.dislikes!.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(
                    () => const CommentsScreen(),
                    arguments: {
                      'posterUid': postModel.userID!,
                      'postID': postModel.docID!,
                      'posterNAME': postModel.userName!,
                      'posterTOKEN': postModel.token!,
                    },
                    transition: Transition.downToUp,
                  );
                },
                icon: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.comment),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 19, 0, 0),
                        child: Text(
                          postModel.comments!.toString(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
