import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sm_project/controller/chat/colors_controller.dart';
import 'package:sm_project/controller/chat/friends_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/models/friends_model.dart';
import 'package:sm_project/view/screens/main/chatscreen/privatechat.dart';
import 'package:sm_project/view/screens/main/media/image/imagescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivatesStream extends GetView<FriendsCon> {
  const PrivatesStream({super.key, required this.myUid});
  final String myUid;
  @override
  Widget build(BuildContext context) {
    ColorsController colorsController = Get.put(ColorsController());

    return GetBuilder<ColorsController>(
      builder: (cC) => GestureDetector(
        onLongPress: () {
          Get.defaultDialog(
            title: 'Select Color',
            content: ColorPicker(
              pickerColor: colorsController.savedFriendsColor,
              pickerAreaHeightPercent: 0.7,
              hexInputBar: true,
              onColorChanged: (color) {
                colorsController.friendsColorSelected(friendsColor: color);
              },
            ),
          );
        },
        child: Container(
          color: colorsController.savedFriendsColor,
          child: StreamBuilder(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GetBuilder<FriendsCon>(
                  builder: (_) => ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      FriendeModel friendModel = FriendeModel.fromMap(
                          snapshot.data!.docs[index].data());
                      bool isEnglish = false;
                      String englishMessage = '';
                      String arabicMessage = '';
                      if (friendModel.thereIsLastMess!) {
                        isEnglish = controller.langCon.checkMessegeLang(
                              friendModel.lastMess!,
                            ) ==
                            'en';
                        englishMessage = friendModel.lastMess!.length < 30
                            ? ' ${friendModel.lastMess!}'
                            : ' ${friendModel.lastMess!.substring(0, 30)}';
                        arabicMessage = friendModel.lastMess!
                                .split(':')
                                .toString()
                                .replaceAll('[]', '')
                                .isNotEmpty
                            ? friendModel.lastMess
                                        .toString()
                                        .split(':')
                                        .length >
                                    1
                                ? friendModel.lastMess!.split(':')[1].length <
                                        30
                                    ? '${friendModel.lastMess!.split(':')[1]} : ${friendModel.lastMess!.split(':')[0]}'
                                    : '${friendModel.lastMess!.split(':')[1].substring(0, 30)} : ${friendModel.lastMess!.split(':')[0]}'
                                : friendModel.lastMess.toString()
                            : '';
                      }
                      if (friendModel.userID == myUid) {
                        return const SizedBox();
                      }
                      if (friendModel.userName == null ||
                          friendModel.profilePicture == null) {
                        return const SizedBox();
                      } else if (controller.myFriendList
                          .contains(friendModel.userID)) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              transition: Transition.downToUp,
                              () => const PrivateChatScreen(),
                              arguments: {
                                'friendUid': friendModel.userID!,
                                'friendPFP': friendModel.profilePicture!,
                                'friendName': friendModel.userName!,
                                'friendToken': friendModel.token!,
                              },
                            );
                          },
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      friendModel.userName!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (friendModel.thereIsLastDate == true)
                                      Text(
                                        friendModel.lastDate!,
                                      ),
                                  ],
                                ),
                                if (friendModel.thereIsLastMess == true)
                                  Text(
                                    isEnglish ? englishMessage : arabicMessage,
                                    textDirection: isEnglish
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                  ),
                              ],
                            ),
                            leading: GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ImageScreen(
                                    heroTag: friendModel.userID! +
                                        friendModel.profilePicture!,
                                    url: friendModel.profilePicture!,
                                  ),
                                  transition: Transition.downToUp,
                                );
                              },
                              child: Hero(
                                tag: friendModel.userID! +
                                    friendModel.profilePicture!,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: CachedNetworkImageProvider(
                                    friendModel.profilePicture!,
                                  ),
                                  backgroundColor: AppColors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                );
              } else {
                return const Text('');
              }
            },
          ),
        ),
      ),
    );
  }
}
