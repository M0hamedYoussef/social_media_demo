import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

class ImageMe extends GetView<PrivateChatsCon> {
  const ImageMe({
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
        ? chatModel.isImgUploaded == false
            ? appCon.loadingImageContainer(
                isMe: true,
                username: chatModel.userName!,
                pfp: chatModel.profilePicture!,
              )
            : SwipeTo(
                key: ValueKey(chatModel.data!),
                onLeftSwipe: () {
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
                  true,
                  false,
                  chatModel.imagePath.toString(),
                  fun: () async {
                    WriteBatch batch = FirebaseFirestore.instance.batch();

                    controller.deleteMessage(messageID: docID);
                    if (chatModel.storageref != null) {
                      controller.deleteFile(
                        chatModel.storageref!,
                      );
                    }

                    await controller.deleteMessage(messageID: docID);
                    await deleteLast();
                    await controller.privatemessagesME!
                        .where(
                          'repliedMessID',
                          isEqualTo: chatModel.imgID,
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
                          isEqualTo: chatModel.imgID,
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
                ? chatModel.isImgUploaded == false
                    ? appCon.loadingImageContainer(
                        isMe: true,
                        username: chatModel.userName!,
                        pfp: chatModel.profilePicture!,
                      )
                    : SwipeTo(
                        key: ValueKey(chatModel.data),
                        onLeftSwipe: () {
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
                                  true,
                                  myLANG: chatModel.toLANG,
                                ),
                              ),
                              appCon.buildImage(
                                chatModel.dateString!,
                                chatModel.profilePicture!,
                                chatModel.userName!,
                                chatModel.image!,
                                true,
                                true,
                                chatModel.imagePath.toString(),
                                fun: () async {
                                  WriteBatch batch =
                                      FirebaseFirestore.instance.batch();

                                  controller.deleteMessage(
                                    messageID: docID,
                                  );
                                  deleteLast();
                                  if (chatModel.storageref != null) {
                                    controller.deleteFile(
                                      chatModel.storageref!,
                                    );
                                  }
                                  await controller.deleteMessage(
                                      messageID: docID);
                                  await deleteLast();
                                  await controller.privatemessagesME!
                                      .where(
                                        'repliedMessID',
                                        isEqualTo: chatModel.imgID,
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
                                        isEqualTo: chatModel.imgID,
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
                              )
                            ],
                          ),
                        ),
                      )
                : chatModel.toType == 'Image'
                    ? chatModel.isImgUploaded == false
                        ? appCon.loadingImageContainer(
                            isMe: true,
                            username: chatModel.userName!,
                            pfp: chatModel.profilePicture!,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: SwipeTo(
                              key: ValueKey(chatModel.data),
                              onLeftSwipe: () {
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
                                    true,
                                  ),
                                  appCon.buildImage(
                                    chatModel.dateString!,
                                    chatModel.profilePicture!,
                                    chatModel.userName!,
                                    chatModel.image!,
                                    true,
                                    false,
                                    chatModel.imagePath.toString(),
                                    fun: () async {
                                      WriteBatch batch =
                                          FirebaseFirestore.instance.batch();

                                      controller.deleteMessage(
                                        messageID: docID,
                                      );
                                      deleteLast();
                                      if (chatModel.storageref != null) {
                                        controller.deleteFile(
                                          chatModel.storageref!,
                                        );
                                      }

                                      await controller.deleteMessage(
                                          messageID: docID);
                                      await deleteLast();
                                      await controller.privatemessagesME!
                                          .where(
                                            'repliedMessID',
                                            isEqualTo: chatModel.imgID,
                                          )
                                          .get()
                                          .then(
                                        (value) {
                                          for (var element in value.docs) {
                                            String myDocID =
                                                element.reference.id;
                                            batch.update(
                                              controller.privatemessagesME!
                                                  .doc(myDocID),
                                              {
                                                'ToType': 'Text',
                                                'repliedMess':
                                                    'deleted message',
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
                                            isEqualTo: chatModel.imgID,
                                          )
                                          .get()
                                          .then(
                                        (value) {
                                          for (var element in value.docs) {
                                            String myDocID =
                                                element.reference.id;
                                            batch.update(
                                              controller.privatemessagesFriend!
                                                  .doc(myDocID),
                                              {
                                                'ToType': 'Text',
                                                'repliedMess':
                                                    'deleted message',
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
            : const SizedBox();
  }
}
