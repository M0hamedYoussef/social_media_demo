import 'package:cached_network_image/cached_network_image.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/models/comments_model.dart';
import 'package:flutter/material.dart';

class CommentImage extends StatelessWidget {
  const CommentImage({super.key, required this.commentsModel});

  final CommentsModel commentsModel;
  @override
  Widget build(BuildContext context) {
    return commentsModel.isImgUploaded == true && commentsModel.image != null
        ? CachedNetworkImage(
            imageUrl: commentsModel.image!,
            fit: BoxFit.fill,
          )
        : const Center(
            child: CircularProgressIndicator(
              color: AppColors.black,
            ),
          );
  }
}
