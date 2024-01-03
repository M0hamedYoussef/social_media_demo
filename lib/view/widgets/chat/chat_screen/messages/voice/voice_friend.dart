import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class VoiceMessageFriend extends GetView<PrivateChatsCon> {
  const VoiceMessageFriend({
    super.key,
    required this.chatModel,
    required this.myUid,
    required this.friendUid,
    required this.friendPfp,
    required this.friendName,
    required this.docID,
    required this.fun,
  });
  final String myUid;
  final String friendUid;
  final String friendPfp;
  final String friendName;
  final String docID;
  final ChatModel chatModel;
  final Function fun;
  @override
  Widget build(BuildContext context) {
    AppCon appCon = Get.find();
    LangCon langCon = Get.find();
    PrivateChatsCon priv = Get.find();

    return chatModel.reply == false
        ? chatModel.isVoiceUploaded == false
            ? appCon.buildLoadingVoiceMessage(
                false,
                true,
                isReply: false,
                pfp: friendPfp,
                username: friendName,
              )
            : GestureDetector(
                onTap: () async {
                  if (priv.currentRecordId == docID) {
                    priv.currentRecordId = '';
                    priv.update();
                    await priv.stopAudio();
                  } else {
                    priv.currentRecordId = docID;
                    priv.update();
                    await priv.playAudio(url: chatModel.voice!);
                  }
                },
                child: SwipeTo(
                  key: ValueKey(chatModel.data),
                  onRightSwipe: () {
                    priv.toLANG = chatModel.messLANG;
                    priv.reply = appCon.replyMess(
                      chatModel.userName!,
                      'Voice Message',
                      myLANG: 'en',
                      fun,
                    );
                    langCon.update();
                    priv.replied = true;
                    priv.repliedTO = chatModel.userName!;
                    priv.repliedMess = 'Voice Message';
                    priv.repliedMessID = chatModel.messageID;
                    priv.toType = 'Text';
                  },
                  child: GetBuilder<PrivateChatsCon>(
                    builder: (_) => appCon.buildVoiceMessage(
                      chatModel.dateString!,
                      docID,
                      false,
                      true,
                      currentDocID: priv.currentRecordId,
                      duration: priv.audioDuration,
                      pos: priv.audioPosition,
                      recordDuration: chatModel.duration!,
                      isReply: false,
                      pfp: friendPfp,
                      username: friendName,
                    ),
                  ),
                ),
              )
        : chatModel.reply == true
            ? chatModel.toType == 'Text'
                ? chatModel.isVoiceUploaded == false
                    ? appCon.buildLoadingVoiceMessage(
                        false,
                        true,
                        isReply: true,
                        pfp: friendPfp,
                        username: friendName,
                      )
                    : SwipeTo(
                        key: ValueKey(chatModel.data),
                        onRightSwipe: () {
                          priv.toLANG = chatModel.messLANG;
                          priv.reply = appCon.replyMess(
                            chatModel.userName!,
                            'Voice Message',
                            myLANG: 'en',
                            fun,
                          );
                          langCon.update();
                          priv.replied = true;
                          priv.repliedTO = chatModel.userName!;
                          priv.repliedMess = 'Voice Message';
                          priv.repliedMessID = chatModel.messageID;
                          priv.toType = 'Text';
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Column(
                            children: [
                              Opacity(
                                opacity: 0.9,
                                child: appCon.buildReplyMess(
                                  friendName,
                                  chatModel.repliedTo!,
                                  chatModel.repliedImg!,
                                  false,
                                  myLANG: chatModel.toLANG,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (priv.currentRecordId == docID) {
                                    priv.currentRecordId = '';
                                    priv.update();
                                    await priv.stopAudio();
                                  } else {
                                    priv.currentRecordId = docID;
                                    priv.update();
                                    await priv.playAudio(url: chatModel.voice!);
                                  }
                                },
                                child: GetBuilder<PrivateChatsCon>(
                                  builder: (_) => appCon.buildVoiceMessage(
                                    chatModel.dateString!,
                                    docID,
                                    false,
                                    true,
                                    currentDocID: priv.currentRecordId,
                                    duration: priv.audioDuration,
                                    pos: priv.audioPosition,
                                    recordDuration: chatModel.duration!,
                                    isReply: true,
                                    pfp: friendPfp,
                                    username: friendName,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                : chatModel.toType == 'Image'
                    ? chatModel.isVoiceUploaded == false
                        ? appCon.buildLoadingVoiceMessage(
                            false,
                            true,
                            isReply: true,
                            pfp: friendPfp,
                            username: friendName,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: SwipeTo(
                              key: ValueKey(chatModel.data),
                              onRightSwipe: () {
                                priv.toLANG = chatModel.messLANG;
                                priv.reply = appCon.replyMess(
                                  chatModel.userName!,
                                  'Voice Message',
                                  myLANG: 'en',
                                  fun,
                                );
                                langCon.update();
                                priv.replied = true;
                                priv.repliedTO = chatModel.userName!;
                                priv.repliedMess = 'Voice Message';
                                priv.repliedMessID = chatModel.messageID;
                                priv.toType = 'Text';
                              },
                              child: Column(
                                children: [
                                  appCon.buildReplyImage(
                                    friendName,
                                    chatModel.repliedTo!,
                                    chatModel.repliedImg!,
                                    false,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (priv.currentRecordId == docID) {
                                        priv.currentRecordId = '';
                                        priv.update();
                                        await priv.stopAudio();
                                      } else {
                                        priv.currentRecordId = docID;
                                        priv.update();
                                        await priv.playAudio(
                                            url: chatModel.voice!);
                                      }
                                    },
                                    child: GetBuilder<PrivateChatsCon>(
                                      builder: (_) => appCon.buildVoiceMessage(
                                        chatModel.dateString!,
                                        docID,
                                        false,
                                        true,
                                        currentDocID: priv.currentRecordId,
                                        duration: priv.audioDuration,
                                        pos: priv.audioPosition,
                                        recordDuration: chatModel.duration!,
                                        isReply: true,
                                        pfp: friendPfp,
                                        username: friendName,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                    : const SizedBox()
            : const SizedBox();
  }
}
