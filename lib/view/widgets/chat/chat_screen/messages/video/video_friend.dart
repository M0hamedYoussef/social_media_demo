import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class VideoFriend extends GetView<PrivateChatsCon> {
  const VideoFriend({
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
        ? chatModel.isVidUploaded == false
            ? appCon.loadingVideoContainer(
                isMe: false,
                username: chatModel.userName!,
                pfp: chatModel.profilePicture!,
              )
            : SwipeTo(
                key: ValueKey(chatModel.data),
                onRightSwipe: () {
                  controller.reply = appCon.replyIMG(
                    chatModel.userName!,
                    chatModel.vidThumb!,
                    fun,
                  );
                  langCon.update();
                  controller.replied = true;
                  controller.repliedTO = chatModel.userName!;
                  controller.repliedMess = chatModel.vidThumb!;
                  controller.repliedMessID = chatModel.vidID;
                  controller.toType = 'Image';
                },
                child: appCon.biuldVid(
                  chatModel.dateString!,
                  chatModel.profilePicture!,
                  chatModel.userName!,
                  chatModel.vid!,
                  chatModel.vidThumb!,
                  false,
                  context,
                ),
              )
        : chatModel.reply == true
            ? chatModel.toType == 'Text'
                ? chatModel.isVidUploaded == false
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
                            chatModel.vidThumb!,
                            fun,
                          );
                          langCon.update();
                          controller.replied = true;
                          controller.repliedTO = chatModel.userName!;
                          controller.repliedMess = chatModel.vidThumb!;
                          controller.repliedMessID = chatModel.vidID;
                          controller.toType = 'Image';
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Column(
                            children: [
                              Opacity(
                                opacity: 0.9,
                                child: appCon.buildReplyMess(
                                  chatModel.userName!,
                                  chatModel.repliedTo!,
                                  chatModel.repliedVid!,
                                  false,
                                  myLANG: chatModel.toLANG,
                                ),
                              ),
                              appCon.biuldVid(
                                chatModel.dateString!,
                                chatModel.profilePicture!,
                                chatModel.userName!,
                                chatModel.vid!,
                                chatModel.vidThumb!,
                                false,
                                context,
                                isReplay: true,
                              )
                            ],
                          ),
                        ),
                      )
                : chatModel.toType == 'Image'
                    ? chatModel.isVidUploaded == false
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
                                  chatModel.vidThumb!,
                                  fun,
                                );
                                langCon.update();
                                controller.replied = true;
                                controller.repliedTO = chatModel.userName!;
                                controller.repliedMess = chatModel.vidThumb;
                                controller.repliedMessID = chatModel.vidID;
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
                                  appCon.biuldVid(
                                    chatModel.dateString!,
                                    chatModel.profilePicture!,
                                    chatModel.userName!,
                                    chatModel.vid!,
                                    chatModel.vidThumb!,
                                    false,
                                    context,
                                    isReplay: true,
                                  )
                                ],
                              ),
                            ),
                          )
                    : const SizedBox()
            : const SizedBox();
  }
}
