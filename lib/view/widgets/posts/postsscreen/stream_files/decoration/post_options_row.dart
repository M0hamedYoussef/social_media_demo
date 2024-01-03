import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:sm_project/controller/chat/speed_dial_controller.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/models/post_model.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/decoration/options_row_files/delete_post.dart';
import 'package:sm_project/view/widgets/posts/postsscreen/stream_files/decoration/options_row_files/edit_post.dart';
import 'package:flutter/material.dart';

class PostOptionsRow extends StatelessWidget {
  const PostOptionsRow({
    super.key,
    required this.myUid,
    required this.postModel,
  });
  final String myUid;
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    if (myUid == postModel.userID) {
      ValueNotifier<bool> hidePostOptions = ValueNotifier(false);
      Get.put(SpeedDialController());
      return GetBuilder<SpeedDialController>(
        builder: (sdCon) {
          return SpeedDial(
            direction: SpeedDialDirection.down,
            icon: Icons.more_vert_outlined,
            onOpen: () {
              sdCon.update();
            },
            onClose: () {
              sdCon.update();
            },
            iconTheme: IconThemeData(
              size: 35,
              color: !hidePostOptions.value ? AppColors.black : AppColors.white,
            ),
            childPadding: const EdgeInsets.only(left: 15),
            activeBackgroundColor: AppColors.darkBlue1,
            key: ValueKey(postModel.data),
            openCloseDial: hidePostOptions,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            buttonSize: const Size.fromRadius(20),
            overlayOpacity: 0.28,
            backgroundColor: AppColors.white,
            children: [
              SpeedDialChild(
                child: EditPost(
                  myUid: myUid,
                  postModel: postModel,
                  openCloseDial: hidePostOptions,
                ),
              ),
              SpeedDialChild(
                child: DeletePost(
                  myUid: myUid,
                  postUserId: postModel.userID!,
                  postId: postModel.docID,
                  postStorageref: postModel.storageref,
                  postStoragerefVid: postModel.storagerefVid,
                  postStoragerefThumb: postModel.storagerefThumb,
                  openCloseDial: hidePostOptions,
                ),
              ),
            ],
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
