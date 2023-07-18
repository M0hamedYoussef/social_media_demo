import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/global/obx_con.dart';
import 'package:social_media_demo/controller/posts/comments_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentSendButton extends StatelessWidget {
  const CommentSendButton(
      {super.key,
      required this.posterNAME,
      required this.posterUid,
      required this.posterTOKEN,
      required this.postID});
  final String posterNAME;
  final String posterUid;
  final String posterTOKEN;
  final String postID;
  @override
  Widget build(BuildContext context) {
    ObxCon obx = Get.put(ObxCon());
    CommentsCon commentsCon = Get.put(CommentsCon());
    LangCon langCon = Get.put(LangCon());

    return IconButton(
      onPressed: () async {
        if (obx.mtcheck!.isNotEmpty) {
          if (obx.mess.text.trim() != '') {
            if (commentsCon.uploadingCommentImage == null &&
                commentsCon.uploadingCommentVid == null) {
              commentsCon.textComment(
                  posterNAME: posterNAME,
                  posterTOKEN: posterTOKEN,
                  posterUID: posterUid,
                  docID: postID,
                  myText: obx.mess.text,
                  myLang: langCon.langTextField == 'en' ? 'en' : 'ar');
              langCon.update();
              obx.mess.clear();
            } else if (commentsCon.uploadingCommentImage == true) {
              commentsCon.bottomWid = const SizedBox();
              commentsCon.uploadCommentImage(
                  posterNAME: posterNAME,
                  posterTOKEN: posterTOKEN,
                  posterUID: posterUid,
                  myLang: langCon.langTextField == 'en' ? 'en' : 'ar',
                  docID: postID,
                  myText: obx.mess.text);
              langCon.update();
              obx.mess.clear();
              commentsCon.update();
            } else if (commentsCon.uploadingCommentVid == true) {
              commentsCon.bottomWid = const SizedBox();
              commentsCon.uploadCommentVid(
                  posterNAME: posterNAME,
                  posterTOKEN: posterTOKEN,
                  posterUID: posterUid,
                  myLang: langCon.langTextField == 'en' ? 'en' : 'ar',
                  docID: postID,
                  myText: obx.mess.text);
              langCon.update();
              obx.mess.clear();
              commentsCon.update();
            }
          } else if (obx.mtcheck!.trim() == '') {
            obx.mess.clear();
          }
        } else if (commentsCon.uploadingCommentImage == true) {
          commentsCon.bottomWid = const SizedBox();
          commentsCon.uploadCommentImage(
              posterNAME: posterNAME,
              posterTOKEN: posterTOKEN,
              posterUID: posterUid,
              myLang: langCon.langTextField == 'en' ? 'en' : 'ar',
              docID: postID,
              myText: obx.mess.text);
          langCon.update();
          obx.mess.clear();
          commentsCon.update();
        } else if (commentsCon.uploadingCommentVid == true) {
          commentsCon.bottomWid = const SizedBox();
          commentsCon.uploadCommentVid(
              posterNAME: posterNAME,
              posterTOKEN: posterTOKEN,
              posterUID: posterUid,
              myLang: langCon.langTextField == 'en' ? 'en' : 'ar',
              docID: postID,
              myText: obx.mess.text);
          langCon.update();
          obx.mess.clear();
          commentsCon.update();
        }
      },
      icon: const Icon(
        size: 25,
        Icons.send,
      ),
    );
  }
}
