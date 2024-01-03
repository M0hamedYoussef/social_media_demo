import 'package:sm_project/models/post_model.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/post/post_image.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/post/post_video.dart';
import 'package:flutter/material.dart';

class PostHandling extends StatelessWidget {
  const PostHandling({super.key, required this.postModel});
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return postModel.textOnly == false
        ? postModel.image == null
            ? PostVideo(postModel: postModel)
            : PostImage(postModel: postModel)
        : const SizedBox();
  }
}
