import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_media_demo/models/post_model.dart';
import 'package:social_media_demo/view/screens/media/image/imagescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key, required this.postModel});
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return postModel.isImgUploaded == true && postModel.image != null
        ? GestureDetector(
            onTap: () {
              Get.to(
                () => ImageScreen(
                  url: postModel.image!,
                  heroTag: postModel.data.toString(),
                ),
                transition: Transition.downToUp,
              );
            },
            child: Hero(
              tag: postModel.data.toString(),
              child: CachedNetworkImage(
                imageUrl: postModel.image!,
                fit: BoxFit.fill,
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
  }
}
