import 'package:social_media_demo/controller/posts/posts_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeletePost extends StatelessWidget {
  const DeletePost({
    super.key,
    required this.myUid,
    required this.postUserId,
    required this.postId,
    required this.postStorageref,
    required this.postStoragerefVid,
    required this.postStoragerefThumb,
  });
  final String myUid;
  final String postUserId;
  final String? postId;
  final String? postStorageref;
  final String? postStoragerefVid;
  final String? postStoragerefThumb;

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());

    return myUid == postUserId
        ? postId != null
            ? GestureDetector(
                onTap: () async {
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
                child: const Icon(Icons.close),
              )
            : const SizedBox()
        : const SizedBox();
  }
}
