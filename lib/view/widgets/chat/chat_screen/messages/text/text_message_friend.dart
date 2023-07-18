import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class TextMessageFriend extends GetView<PrivateChatsCon> {
  const TextMessageFriend({
    super.key,
    required this.chatModel,
    required this.myUid,
    required this.friendUid,
    required this.docID,
    required this.fun,
  });
  final String myUid;
  final String friendUid;
  final String docID;
  final ChatModel chatModel;
  final Function fun;
  @override
  Widget build(BuildContext context) {
    AppCon appCon = Get.find();
    LangCon langCon = Get.find();
    return chatModel.reply == false
        ? SwipeTo(
            key: ValueKey(chatModel.data),
            onRightSwipe: () {
              controller.toLANG = chatModel.messLANG;
              controller.reply = appCon.replyMess(
                chatModel.userName!,
                chatModel.message!,
                fun,
                myLANG: chatModel.messLANG,
              );

              langCon.update();
              controller.replied = true;
              controller.repliedTO = chatModel.userName!;
              controller.repliedMess = chatModel.message!;
              controller.repliedMessID = chatModel.messageID;
              controller.toType = 'Text';
            },
            child: appCon.buildMessage(
              chatModel.dateString!,
              docID,
              chatModel.message!,
              chatModel.profilePicture!,
              chatModel.userName!,
              chatModel.message!,
              false,
              true,
              friendUid: friendUid,
              myUid: myUid,
              isReply: false,
              myLANG: chatModel.messLANG,
            ),
          )
        : chatModel.reply == true
            ? chatModel.toType == 'Text'
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: SwipeTo(
                      key: ValueKey(chatModel.data),
                      onRightSwipe: () {
                        controller.toType = chatModel.messLANG;
                        controller.reply = appCon.replyMess(
                          chatModel.userName!,
                          chatModel.message!,
                          fun,
                          myLANG: chatModel.messLANG,
                        );
                        langCon.update();
                        controller.replied = true;
                        controller.repliedTO = chatModel.userName!;
                        controller.repliedMess = chatModel.message!;
                        controller.repliedMessID = chatModel.messageID;
                        controller.toType = 'Text';
                      },
                      child: Column(
                        children: [
                          Opacity(
                            opacity: 0.9,
                            child: appCon.buildReplyMess(
                              chatModel.userName!,
                              chatModel.repliedTo!,
                              chatModel.repliedMessage!,
                              false,
                              myLANG: chatModel.toLANG,
                            ),
                          ),
                          appCon.buildMessage(
                            chatModel.dateString!,
                            docID,
                            chatModel.message!,
                            chatModel.profilePicture!,
                            chatModel.userName!,
                            chatModel.message!,
                            false,
                            true,
                            friendUid: friendUid,
                            myUid: myUid,
                            isReply: true,
                            myLANG: chatModel.messLANG,
                          ),
                        ],
                      ),
                    ),
                  )
                : chatModel.toType == 'Image'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: SwipeTo(
                          key: ValueKey(
                            chatModel.data,
                          ),
                          onRightSwipe: () {
                            controller.toLANG = chatModel.messLANG;
                            controller.reply = appCon.replyMess(
                              chatModel.userName!,
                              chatModel.message!,
                              fun,
                              myLANG: chatModel.messLANG,
                            );
                            langCon.update();
                            controller.replied = true;
                            controller.repliedTO = chatModel.userName!;
                            controller.repliedMess = chatModel.message!;
                            controller.repliedMessID = chatModel.messageID;
                            controller.toType = 'Text';
                          },
                          child: Column(
                            children: [
                              appCon.buildReplyImage(
                                chatModel.userName!,
                                chatModel.repliedTo!,
                                chatModel.repliedImg!,
                                false,
                              ),
                              appCon.buildMessage(
                                chatModel.dateString!,
                                docID,
                                chatModel.message!,
                                chatModel.profilePicture!,
                                chatModel.userName!,
                                chatModel.message!,
                                false,
                                true,
                                friendUid: friendUid,
                                myUid: myUid,
                                isReply: true,
                                myLANG: chatModel.messLANG,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()
            : const SizedBox();
  }
}
