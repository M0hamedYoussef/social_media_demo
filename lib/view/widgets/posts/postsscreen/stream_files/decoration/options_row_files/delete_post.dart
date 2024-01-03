import 'package:sm_project/controller/posts/posts_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';

class DeletePost extends StatelessWidget {
  const DeletePost({
    super.key,
    required this.myUid,
    required this.postUserId,
    required this.postId,
    required this.postStorageref,
    required this.postStoragerefVid,
    required this.postStoragerefThumb,
    required this.openCloseDial,
  });
  final String myUid;
  final String postUserId;
  final String? postId;
  final String? postStorageref;
  final String? postStoragerefVid;
  final String? postStoragerefThumb;
  final ValueNotifier openCloseDial;

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());

    return GestureDetector(
      onTap: () async {
        openCloseDial.value = !openCloseDial.value;
        postsCon.deleteDoc(
          postId!,
        );
        if (postStorageref != null) {
          postsCon.deleteFile(
            postStorageref!,
          );
        }
        if (postStoragerefVid != null) {
          postsCon.deleteFile(
            postStoragerefVid!,
          );
          postsCon.deleteFile(
            postStoragerefThumb!,
          );
        }
      },
      child: const Icon(
        Icons.close,
        color: AppColors.darkBlue1,
      ),
    );
  }
}
