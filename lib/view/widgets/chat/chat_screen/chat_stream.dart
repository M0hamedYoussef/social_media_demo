import 'package:sm_project/controller/chat/colors_controller.dart';
import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/models/chat_model.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/image/image_friend.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/image/image_me.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/text/text_message_friend.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/text/text_message_me.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/video/video_friend.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/video/video_me.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/voice/voice_friend.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/messages/voice/voice_me.dart';

class ChatStream extends StatelessWidget {
  const ChatStream({super.key, required this.myUid, required this.friendUid});
  final String myUid;
  final String friendUid;
  @override
  Widget build(BuildContext context) {
    PrivateChatsCon priv = Get.put(PrivateChatsCon());
    deleteLast() async {
      await priv.deleteLast();
    }

    LangCon langCon = Get.put(LangCon());
    ColorsController colorsController = Get.put(ColorsController());
    return Expanded(
      child: GestureDetector(
        onLongPress: () {
          Get.defaultDialog(
            title: 'Select Color',
            content: ColorPicker(
              pickerColor: colorsController.savedChatColor,
              pickerAreaHeightPercent: 0.7,
              hexInputBar: true,
              onColorChanged: (color) {
                colorsController.chatColorSelected(chatColor: color);
              },
            ),
          );
        },
        child: GetBuilder<ColorsController>(
          builder: (cC) => Container(
            color: cC.savedChatColor,
            child: StreamBuilder(
              stream: priv.privatemessagesME!
                  .orderBy(
                    'date',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      ChatModel chatModel =
                          ChatModel.fromMap(snapshot.data!.docs[index].data());
                      countedMessages() {
                        return priv.countedMessages();
                      }

                      setMess(date, mess) async {
                        await priv.setMess(date, mess);
                      }

                      if (chatModel.userID ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        if (chatModel.message != null) {
                          if (countedMessages() == index) {
                            final dateFormat = DateFormat('h:mm a');
                            final dateFormated = dateFormat.format(
                              DateTime.parse(
                                chatModel.dateString!,
                              ),
                            );
                            setMess(
                              dateFormated,
                              '${chatModel.userName} : ${chatModel.message}',
                            );
                          }
                          String docID =
                              snapshot.data!.docs[index].reference.id;
                          fun() {
                            priv.reply = const SizedBox();
                            priv.replied = false;
                            langCon.update();
                          }

                          return TextMessageMe(
                            chatModel: chatModel,
                            myUid: myUid,
                            friendUid: friendUid,
                            docID: docID,
                            deleteLast: deleteLast,
                            fun: fun,
                          );
                        } else if (chatModel.isVoiceUploaded != null) {
                          if (countedMessages() == index) {
                            final dateFormat = DateFormat('h:mm a');
                            final dateFormated = dateFormat.format(
                              DateTime.parse(
                                chatModel.dateString!,
                              ),
                            );
                            setMess(
                              dateFormated,
                              '${chatModel.userName} : Voice Message',
                            );
                          }
                          String docID =
                              snapshot.data!.docs[index].reference.id;
                          fun() async {
                            priv.reply = const SizedBox();
                            priv.replied = false;
                            langCon.update();
                          }

                          return VoiceMessageMe(
                            chatModel: chatModel,
                            myUid: myUid,
                            friendUid: friendUid,
                            docID: docID,
                            fun: fun,
                            deleteLast: deleteLast,
                          );
                        } else if (chatModel.isImgUploaded != null) {
                          if (countedMessages() == index) {
                            final dateFormat = DateFormat('h:mm a');
                            final dateFormated = dateFormat
                                .format(DateTime.parse(chatModel.dateString!));
                            setMess(dateFormated,
                                '${chatModel.userName!} sent a image');
                          }
                          fun() {
                            priv.replied = false;
                            priv.reply = const SizedBox();
                            langCon.update();
                          }

                          String docID =
                              snapshot.data!.docs[index].reference.id;
                          return ImageMe(
                            chatModel: chatModel,
                            myUid: myUid,
                            friendUid: friendUid,
                            docID: docID,
                            deleteLast: deleteLast,
                            fun: fun,
                          );
                        } else if (chatModel.isVidUploaded != null) {
                          if (countedMessages() == index) {
                            final dateFormat = DateFormat('h:mm a');
                            final dateFormated = dateFormat
                                .format(DateTime.parse(chatModel.dateString!));
                            setMess(dateFormated,
                                '${chatModel.userName!} sent a video');
                          }
                          String docID =
                              snapshot.data!.docs[index].reference.id;
                          fun() {
                            priv.replied = false;
                            priv.reply = const SizedBox();
                            langCon.update();
                          }

                          return VideoMe(
                            chatModel: chatModel,
                            myUid: myUid,
                            friendUid: friendUid,
                            docID: docID,
                            fun: fun,
                            deleteLast: deleteLast,
                          );
                        }
                      } else if (chatModel.userID !=
                          FirebaseAuth.instance.currentUser!.uid) {
                        if (chatModel.message != null) {
                          if (countedMessages() == index) {
                            final String dateFormated =
                                DateFormat('h:mm a').format(
                              DateTime.parse(
                                chatModel.dateString!,
                              ),
                            );
                            setMess(dateFormated,
                                '${chatModel.userName!} : ${chatModel.message!}');
                          }

                          String docID =
                              snapshot.data!.docs[index].reference.id;
                          fun() {
                            priv.reply = const SizedBox();
                            priv.replied = false;
                            langCon.update();
                          }

                          return TextMessageFriend(
                            chatModel: chatModel,
                            myUid: myUid,
                            friendUid: friendUid,
                            friendName: priv.friendName,
                            friendPfp: priv.friendPFP,
                            docID: docID,
                            fun: fun,
                          );
                        } else if (chatModel.isVoiceUploaded != null) {
                          if (countedMessages() == index) {
                            final dateFormat = DateFormat('h:mm a');
                            final dateFormated = dateFormat.format(
                              DateTime.parse(
                                chatModel.dateString!,
                              ),
                            );
                            setMess(
                              dateFormated,
                              '${chatModel.userName} : Voice Message',
                            );
                          }
                          String docID =
                              snapshot.data!.docs[index].reference.id;
                          fun() async {
                            priv.reply = const SizedBox();
                            priv.replied = false;
                            langCon.update();
                          }

                          return VoiceMessageFriend(
                            chatModel: chatModel,
                            myUid: myUid,
                            friendUid: friendUid,
                            friendName: priv.friendName,
                            friendPfp: priv.friendPFP,
                            docID: docID,
                            fun: fun,
                          );
                        } else if (chatModel.isImgUploaded != null) {
                          fun() {
                            priv.reply = const SizedBox();
                            priv.replied = false;
                            langCon.update();
                          }

                          if (countedMessages() == index) {
                            final dateFormat = DateFormat('h:mm a');
                            final dateFormated = dateFormat
                                .format(DateTime.parse(chatModel.dateString!));
                            setMess(dateFormated,
                                '${chatModel.userName!} sent a image');
                          }
                          return ImageFriend(
                            chatModel: chatModel,
                            myUid: myUid,
                            friendName: priv.friendName,
                            friendPfp: priv.friendPFP,
                            friendUid: friendUid,
                            fun: fun,
                          );
                        } else if (chatModel.isVidUploaded != null) {
                          if (countedMessages() == index) {
                            final dateFormat = DateFormat('h:mm a');
                            final dateFormated = dateFormat
                                .format(DateTime.parse(chatModel.dateString!));
                            setMess(dateFormated,
                                '${chatModel.userName!} sent a video');
                          }

                          fun() {
                            priv.replied = false;
                            priv.reply = const SizedBox();
                            langCon.update();
                          }

                          return VideoFriend(
                            chatModel: chatModel,
                            friendName: priv.friendName,
                            friendPfp: priv.friendPFP,
                            myUid: myUid,
                            friendUid: friendUid,
                            fun: fun,
                          );
                        }
                      }
                      return const Text('');
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('');
                }

                return const Text('Null !!!!!');
              },
            ),
          ),
        ),
      ),
    );
  }
}
