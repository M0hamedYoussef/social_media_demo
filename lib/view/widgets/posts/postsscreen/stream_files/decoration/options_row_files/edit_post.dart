import 'package:sm_project/controller/posts/posts_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class EditPost extends StatelessWidget {
  const EditPost({
    super.key,
    required this.myUid,
    required this.postModel,
    required this.openCloseDial,
  });
  final String myUid;
  final PostModel postModel;
  final ValueNotifier openCloseDial;

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());

    return GestureDetector(
      onTap: () {
        openCloseDial.value = !openCloseDial.value;
        postsCon.editDia(
          oldPost: postModel.text!,
          textOnly: postModel.textOnly!,
          postDIR: postModel.textLang == 'en'
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          postID: postModel.docID!,
        );
      },
      child: const Icon(
        Icons.edit,
        color: AppColors.darkBlue1,
      ),
    );
  }
}
