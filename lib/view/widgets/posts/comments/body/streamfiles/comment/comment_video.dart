import 'package:cached_network_image/cached_network_image.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/models/comments_model.dart';
import 'package:sm_project/view/screens/main/media/video/videoscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentVideo extends StatelessWidget {
  const CommentVideo({super.key, required this.commentsModel});

  final CommentsModel commentsModel;
  @override
  Widget build(BuildContext context) {
    return commentsModel.isVidUploaded == true && commentsModel.vid != null
        ? GestureDetector(
            onTap: () {
              Get.to(
                () => const VideoScreen(),
                transition: Transition.downToUp,
                arguments: {
                  'url': commentsModel.vid,
                },
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: commentsModel.vidthumb!,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.6),
                        spreadRadius: -2,
                        blurRadius: 0,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.play_arrow,
                      color: AppColors.white,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: AppColors.black,
            ),
          );
  }
}
