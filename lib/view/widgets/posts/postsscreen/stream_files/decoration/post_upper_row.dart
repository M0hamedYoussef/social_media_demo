import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/models/post_model.dart';
import 'package:sm_project/view/screens/main/media/image/imagescreen.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/decoration/post_options_row.dart';
import 'package:flutter/material.dart';

class PostsUpperRow extends StatelessWidget {
  const PostsUpperRow({
    super.key,
    required this.myUid,
    required this.dateFormated,
    required this.postModel,
  });
  final String myUid;
  final String dateFormated;
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
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
                          () => ImageScreen(
                            url: postModel.profilePicture!,
                            heroTag: postModel.profilePicture! +
                                postModel.data.toString(),
                          ),
                          transition: Transition.downToUp,
                        );
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.black,
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
                        Text(Jiffy.parse(dateFormated).fromNow()),
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
      ),
    );
  }
}
