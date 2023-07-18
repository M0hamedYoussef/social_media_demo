import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_media_demo/models/post_model.dart';
import 'package:social_media_demo/view/screens/media/image/imagescreen.dart';
import 'package:social_media_demo/view/widgets/posts/postsscreen/stream_files/decoration/post_options_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsUpperRow extends StatelessWidget {
  const PostsUpperRow(
      {super.key,
      required this.myUid,
      required this.dateFormated,
      required this.postModel});
  final String myUid;
  final String dateFormated;
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Hero(
                  tag: postModel.profilePicture! + postModel.data.toString(),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        ImageScreen(
                          url: postModel.profilePicture!,
                          heroTag: postModel.profilePicture! +
                              postModel.data.toString(),
                        ),
                        transition: Transition.downToUp,
                      );
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.black,
                      backgroundImage: CachedNetworkImageProvider(
                        postModel.profilePicture!,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postModel.userName!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(dateFormated),
                    ],
                  ),
                ),
              ],
            ),
            PostOptionsRow(
              myUid: myUid,
              postModel: postModel,
            ),
          ],
        ),
      ],
    );
  }
}
