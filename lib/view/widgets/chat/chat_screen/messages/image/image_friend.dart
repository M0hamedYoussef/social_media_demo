import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class ImageFriend extends GetView<PrivateChatsCon> {
  const ImageFriend({
    super.key,
    required this.chatModel,
    required this.myUid,
    required this.friendUid,
    required this.fun,
  });
  final String myUid;
  final String friendUid;
  final ChatModel chatModel;
  final Function fun;
  @override
  Widget build(BuildContext context) {
    AppCon appCon = Get.find();
    LangCon langCon = Get.find();
    return chatModel.reply == false
        ? chatModel.isImgUploaded == false
            ? appCon.loadingImageContainer(
                isMe: false,
                username: chatModel.userName!,
                pfp: chatModel.profilePicture!,
              )
            : SwipeTo(
                key: ValueKey(
                  chatModel.data,
                ),
                onRightSwipe: () {
                  controller.reply = appCon.replyIMG(
                    chatModel.userName!,
                    chatModel.image!,
                    fun,
                  );
                  langCon.update();
                  controller.replied = true;
                  controller.repliedTO = chatModel.userName!;
                  controller.repliedMess = chatModel.image!;
                  controller.repliedMessID = chatModel.imgID;
                  controller.toType = 'Image';
                },
                child: appCon.buildImage(
                  chatModel.dateString!,
                  chatModel.profilePicture!,
                  chatModel.userName!,
                  chatModel.image!,
                  false,
                  false,
                  chatModel.imagePath.toString(),
                ),
              )
        : chatModel.reply == true
            ? chatModel.toType == 'Text'
                ? chatModel.isImgUploaded == false
                    ? appCon.loadingImageContainer(
                        isMe: false,
                        username: chatModel.userName!,
                        pfp: chatModel.profilePicture!,
                      )
                    : SwipeTo(
                        key: ValueKey(chatModel.data),
                        onRightSwipe: () {
                          controller.reply = appCon.replyIMG(
                            chatModel.userName!,
                            chatModel.image!,
                            fun,
                          );
                          langCon.update();
                          controller.replied = true;
                          controller.repliedTO = chatModel.userName!;
                          controller.repliedMess = chatModel.image!;
                          controller.repliedMessID = chatModel.imgID;
                          controller.toType = 'Image';
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Column(
                            children: [
                              Opacity(
                                opacity: 0.9,
                                child: appCon.buildReplyMess(
                                  appCon.name!,
                                  chatModel.repliedTo!,
                                  chatModel.repliedImg!,
                                  false,
                                  myLANG: chatModel.toLANG,
                                ),
                              ),
                              appCon.buildImage(
                                chatModel.dateString!,
                                chatModel.profilePicture!,
                                chatModel.userName!,
                                chatModel.image!,
                                false,
                                true,
                                isToTextReplay: true,
                                chatModel.imagePath.toString(),
                              ),
                            ],
                          ),
                        ),
                      )
                : chatModel.toType == 'Image'
                    ? chatModel.isImgUploaded == false
                        ? appCon.loadingImageContainer(
                            isMe: false,
                            username: chatModel.userName!,
                            pfp: chatModel.profilePicture!,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: SwipeTo(
                              key: ValueKey(chatModel.data),
                              onRightSwipe: () {
                                controller.reply = appCon.replyIMG(
                                  chatModel.userName!,
                                  chatModel.image!,
                                  fun,
                                );
                                langCon.update();
                                controller.replied = true;
                                controller.repliedTO = chatModel.userName!;
                                controller.repliedMess = chatModel.image!;
                                controller.repliedMessID = chatModel.imgID;
                                controller.toType = 'Image';
                              },
                              child: Column(
                                children: [
                                  appCon.buildReplyImage(
                                    appCon.name!,
                                    chatModel.repliedTo!,
                                    chatModel.repliedImg!,
                                    false,
                                  ),
                                  appCon.buildImage(
                                    chatModel.dateString!,
                                    chatModel.profilePicture!,
                                    chatModel.userName!,
                                    chatModel.image!,
                                    false,
                                    true,
                                    chatModel.imagePath.toString(),
                                  ),
                                ],
                              ),
                            ),
                          )
                    : const SizedBox()
            : const SizedBox();
  }
}
