import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class VoiceMessageMe extends GetView<PrivateChatsCon> {
  const VoiceMessageMe({
    super.key,
    required this.chatModel,
    required this.myUid,
    required this.friendUid,
    required this.docID,
    required this.fun,
    required this.deleteLast,
  });
  final String myUid;
  final String friendUid;
  final String docID;
  final ChatModel chatModel;
  final Function fun;
  final dynamic deleteLast;
  @override
  Widget build(BuildContext context) {
    AppCon appCon = Get.find();
    LangCon langCon = Get.find();
    PrivateChatsCon priv = Get.find();
    return chatModel.reply == false
        ? chatModel.isVoiceUploaded == false
            ? appCon.buildLoadingVoiceMessage(
                true,
                true,
                isReply: false,
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
                  onLeftSwipe: () {
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
                      true,
                      true,
                      currentDocID: priv.currentRecordId,
                      duration: priv.audioDuration,
                      pos: priv.audioPosition,
                      recordDuration: chatModel.duration!,
                      isReply: false,
                      fun: () async {
                        await priv.deleteMessage(messageID: docID);
                        await priv.deleteFile(chatModel.storageref!);
                      },
                    ),
                  ),
                ),
              )
        : chatModel.reply == true
            ? chatModel.isVoiceUploaded == false
                ? appCon.buildLoadingVoiceMessage(
                    true,
                    true,
                    isReply: true,
                  )
                : chatModel.toType == 'Text'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: SwipeTo(
                          key: ValueKey(chatModel.data),
                          onLeftSwipe: () {
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
                              Opacity(
                                opacity: 0.9,
                                child: appCon.buildReplyMess(
                                  appCon.name!,
                                  chatModel.repliedTo!,
                                  chatModel.repliedMessage!,
                                  true,
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
                                    true,
                                    true,
                                    currentDocID: priv.currentRecordId,
                                    duration: priv.audioDuration,
                                    pos: priv.audioPosition,
                                    recordDuration: chatModel.duration!,
                                    isReply: false,
                                    fun: () async {
                                      await priv.deleteMessage(
                                          messageID: docID);
                                      await priv
                                          .deleteFile(chatModel.storageref!);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : chatModel.toType == 'Image'
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: SwipeTo(
                              key: ValueKey(chatModel.data),
                              onLeftSwipe: () {
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
                                  Opacity(
                                    opacity: 0.9,
                                    child: appCon.buildReplyImage(
                                      appCon.name!,
                                      chatModel.repliedTo!,
                                      chatModel.repliedImg!,
                                      true,
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
                                        await priv.playAudio(
                                            url: chatModel.voice!);
                                      }
                                    },
                                    child: GetBuilder<PrivateChatsCon>(
                                      builder: (_) => appCon.buildVoiceMessage(
                                        chatModel.dateString!,
                                        docID,
                                        true,
                                        true,
                                        currentDocID: priv.currentRecordId,
                                        duration: priv.audioDuration,
                                        pos: priv.audioPosition,
                                        recordDuration: chatModel.duration!,
                                        isReply: false,
                                        fun: () async {
                                          await priv.deleteMessage(
                                              messageID: docID);
                                          await priv.deleteFile(
                                              chatModel.storageref!);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox()
            : const Text('');
  }
}
