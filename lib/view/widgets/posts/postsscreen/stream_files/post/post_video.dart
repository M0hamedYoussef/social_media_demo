import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_media_demo/models/post_model.dart';
import 'package:social_media_demo/view/screens/media/video/videoscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostVideo extends StatelessWidget {
  const PostVideo({super.key, required this.postModel});
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return postModel.isVidUploaded == true && postModel.vid != null
        ? GestureDetector(
            onTap: () {
              Get.to(
                () => const VideoScreen(),
                transition: Transition.downToUp,
                arguments: {
                  'url': postModel.vid,
                },
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: postModel.vidthumb!,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
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
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
  }
}
