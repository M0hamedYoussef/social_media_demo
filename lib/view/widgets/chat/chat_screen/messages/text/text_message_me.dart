import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class TextMessageMe extends GetView<PrivateChatsCon> {
  const TextMessageMe({
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
    return chatModel.reply == false
        ? SwipeTo(
            key: ValueKey(chatModel.data),
            onLeftSwipe: () {
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
              true,
              true,
              friendUid: friendUid,
              myUid: myUid,
              isReply: false,
              myLANG: chatModel.messLANG,
              fun: () async {
                WriteBatch batch = FirebaseFirestore.instance.batch();

                await controller.deleteMessage(messageID: docID);
                await deleteLast();
                await controller.privatemessagesME!
                    .where(
                      'repliedMessID',
                      isEqualTo: chatModel.messageID,
                    )
                    .get()
                    .then(
                  (value) {
                    for (var element in value.docs) {
                      String myDocID = element.reference.id;
                      batch.update(
                        controller.privatemessagesME!.doc(myDocID),
                        {
                          'ToType': 'Text',
                          'repliedMess': 'deleted message',
                          'repliedImg': 'deleted message',
                          'repliedVid': 'deleted message',
                        },
                      );
                    }
                  },
                );
                await controller.privatemessagesFriend!
                    .where(
                      'repliedMessID',
                      isEqualTo: chatModel.messageID,
                    )
                    .get()
                    .then(
                  (value) {
                    for (var element in value.docs) {
                      String myDocID = element.reference.id;
                      batch.update(
                        controller.privatemessagesFriend!.doc(myDocID),
                        {
                          'ToType': 'Text',
                          'repliedMess': 'deleted message',
                          'repliedImg': 'deleted message',
                          'repliedVid': 'deleted message',
                        },
                      );
                    }
                  },
                );
                await batch.commit();
              },
            ),
          )
        : chatModel.reply == true
            ? chatModel.toType == 'Text'
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: SwipeTo(
                      key: ValueKey(chatModel.data),
                      onLeftSwipe: () {
                        controller.toLANG = chatModel.messLANG;
                        controller.reply = appCon.replyMess(
                          chatModel.userName!,
                          chatModel.message!,
                          myLANG: controller.toLANG,
                          fun,
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
                              appCon.name!,
                              chatModel.repliedTo!,
                              chatModel.repliedMessage!,
                              true,
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
                            true,
                            true,
                            friendUid: friendUid,
                            myUid: myUid,
                            isReply: true,
                            myLANG: chatModel.messLANG,
                            fun: () async {
                              WriteBatch batch =
                                  FirebaseFirestore.instance.batch();

                              await controller.deleteMessage(messageID: docID);
                              await deleteLast();
                              await controller.privatemessagesME!
                                  .where(
                                    'repliedMessID',
                                    isEqualTo: chatModel.messageID,
                                  )
                                  .get()
                                  .then(
                                (value) {
                                  for (var element in value.docs) {
                                    String myDocID = element.reference.id;
                                    batch.update(
                                      controller.privatemessagesME!
                                          .doc(myDocID),
                                      {
                                        'ToType': 'Text',
                                        'repliedMess': 'deleted message',
                                        'repliedImg': 'deleted message',
                                        'repliedVid': 'deleted message',
                                      },
                                    );
                                  }
                                },
                              );
                              await controller.privatemessagesFriend!
                                  .where(
                                    'repliedMessID',
                                    isEqualTo: chatModel.messageID,
                                  )
                                  .get()
                                  .then(
                                (value) {
                                  for (var element in value.docs) {
                                    String myDocID = element.reference.id;
                                    batch.update(
                                      controller.privatemessagesFriend!
                                          .doc(myDocID),
                                      {
                                        'ToType': 'Text',
                                        'repliedMess': 'deleted message',
                                        'repliedImg': 'deleted message',
                                        'repliedVid': 'deleted message',
                                      },
                                    );
                                  }
                                },
                              );
                              await batch.commit();
                            },
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
                            chatModel.data!,
                          ),
                          onLeftSwipe: () {
                            controller.toLANG = chatModel.messLANG;
                            controller.reply = appCon.replyMess(
                              chatModel.userName!,
                              chatModel.message!,
                              fun,
                              myLANG: controller.toLANG,
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
                                child: appCon.buildReplyImage(
                                  appCon.name!,
                                  chatModel.repliedTo!,
                                  chatModel.repliedImg!,
                                  true,
                                ),
                              ),
                              appCon.buildMessage(
                                chatModel.dateString!,
                                docID,
                                chatModel.message!,
                                chatModel.profilePicture!,
                                chatModel.userName!,
                                chatModel.message!,
                                true,
                                true,
                                friendUid: friendUid,
                                myUid: myUid,
                                isReply: true,
                                myLANG: chatModel.messLANG,
                                fun: () async {
                                  WriteBatch batch =
                                      FirebaseFirestore.instance.batch();

                                  await controller.deleteMessage(
                                      messageID: docID);
                                  await deleteLast();
                                  await controller.privatemessagesME!
                                      .where(
                                        'repliedMessID',
                                        isEqualTo: chatModel.messageID,
                                      )
                                      .get()
                                      .then(
                                    (value) {
                                      for (var element in value.docs) {
                                        String myDocID = element.reference.id;
                                        batch.update(
                                          controller.privatemessagesME!
                                              .doc(myDocID),
                                          {
                                            'ToType': 'Text',
                                            'repliedMess': 'deleted message',
                                            'repliedImg': 'deleted message',
                                            'repliedVid': 'deleted message',
                                          },
                                        );
                                      }
                                    },
                                  );
                                  await controller.privatemessagesFriend!
                                      .where(
                                        'repliedMessID',
                                        isEqualTo: chatModel.messageID,
                                      )
                                      .get()
                                      .then(
                                    (value) {
                                      for (var element in value.docs) {
                                        String myDocID = element.reference.id;
                                        batch.update(
                                          controller.privatemessagesFriend!
                                              .doc(myDocID),
                                          {
                                            'ToType': 'Text',
                                            'repliedMess': 'deleted message',
                                            'repliedImg': 'deleted message',
                                            'repliedVid': 'deleted message',
                                          },
                                        );
                                      }
                                    },
                                  );
                                  await batch.commit();
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()
            : const Text('');
  }
}
