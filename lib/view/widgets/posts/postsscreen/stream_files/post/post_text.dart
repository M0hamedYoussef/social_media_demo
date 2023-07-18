import 'package:social_media_demo/models/post_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PostText extends StatelessWidget {
  const PostText({super.key, required this.postModel});
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 3, 7, 4),
      child: Text(
        postModel.text!,
        style: const TextStyle(
          fontSize: 20,
        ),
        textDirection: postModel.textLang == 'en'
            ? ui.TextDirection.ltr
            : ui.TextDirection.rtl,
      ),
    );
  }
}
