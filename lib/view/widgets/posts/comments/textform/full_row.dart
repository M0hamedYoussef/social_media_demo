import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/view/widgets/posts/comments/textform/buttons/send_button.dart';
import 'package:sm_project/view/widgets/posts/comments/textform/buttons/upload_button.dart';
import 'package:sm_project/view/widgets/posts/comments/textform/textform/comments_text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsFormRow extends StatelessWidget {
  const CommentsFormRow({
    super.key,
    required this.focusNodeIcon,
    required this.posterNAME,
    required this.posterUid,
    required this.posterTOKEN,
    required this.postID,
  });
  final FocusNode focusNodeIcon;
  final String posterNAME;
  final String posterUid;
  final String posterTOKEN;
  final String postID;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LangCon>(
      builder: (c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            CommentsTextForm(focusNodeIcon: focusNodeIcon),
            const CommentsUploadButton(),
            CommentSendButton(
              posterNAME: posterNAME,
              posterUid: posterUid,
              posterTOKEN: posterTOKEN,
              postID: postID,
            ),
          ],
        ),
      ),
    );
  }
}
