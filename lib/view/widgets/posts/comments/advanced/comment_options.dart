import 'package:sm_project/controller/posts/comments_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class CommentOptions extends StatelessWidget {
  const CommentOptions({super.key, required this.data, required this.myUid});
  final dynamic data;
  final String myUid;
  @override
  Widget build(BuildContext context) {
    CommentsCon commentsCon = Get.put(CommentsCon());

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        myUid == data['UserID']
            ? data['commentID'] != null
                ? GestureDetector(
                    onTap: () {
                      commentsCon.editDia(
                        oldPost: data['text'],
                        postDIR: data['textLANG'] == 'en'
                            ? ui.TextDirection.ltr
                            : ui.TextDirection.rtl,
                        postID: data['commentID'],
                        textOnly: data['textOnly'],
                      );
                    },
                    child: const Icon(Icons.edit),
                  )
                : const SizedBox()
            : const SizedBox(),
        myUid == data['UserID']
            ? data['commentID'] != null
                ? GestureDetector(
                    onTap: () {
                      commentsCon.deleteDoc(
                        data['commentID'],
                      );
                      if (data['storageref'] != null) {
                        commentsCon.deleteFile(
                          data['storageref'],
                        );
                      }
                    },
                    child: const Icon(Icons.close),
                  )
                : const SizedBox()
            : const SizedBox(),
      ],
    );
  }
}
