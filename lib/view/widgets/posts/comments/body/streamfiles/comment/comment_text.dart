import 'package:sm_project/models/comments_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CommentText extends StatelessWidget {
  const CommentText({super.key, required this.commentsModel});
  final CommentsModel commentsModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 7, 4),
      child: Text(
        commentsModel.text!,
        style: const TextStyle(
          fontSize: 20,
        ),
        textDirection: commentsModel.textLang == 'en'
            ? ui.TextDirection.ltr
            : ui.TextDirection.rtl,
      ),
    );
  }
}
