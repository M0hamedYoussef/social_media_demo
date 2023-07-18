import 'package:social_media_demo/controller/posts/posts_con.dart';
import 'package:social_media_demo/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class EditPost extends StatelessWidget {
  const EditPost({
    super.key,
    required this.myUid,
    required this.postModel,
  });
  final String myUid;
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());

    return myUid == postModel.userID
        ? postModel.docID != null
            ? GestureDetector(
                onTap: () {
                  postsCon.editDia(
                    oldPost: postModel.text!,
                    textOnly: postModel.textOnly!,
                    postDIR: postModel.textLang == 'en'
                        ? ui.TextDirection.ltr
                        : ui.TextDirection.rtl,
                    postID: postModel.docID!,
                  );
                },
                child: const Icon(Icons.edit),
              )
            : const SizedBox()
        : const SizedBox();
  }
}
