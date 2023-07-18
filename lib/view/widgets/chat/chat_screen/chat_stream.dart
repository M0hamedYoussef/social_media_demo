import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/models/chat_model.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/messages/image/image_friend.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/messages/image/image_me.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/messages/text/text_message_friend.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/messages/text/text_message_me.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/messages/video/video_friend.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/messages/video/video_me.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    MyServices myServices = Get.find();
    return Expanded(
      child: StreamBuilder(
        stream: myServices.oneStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              child: ListView.builder(
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
                      String docID = snapshot.data!.docs[index].reference.id;
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

                      String docID = snapshot.data!.docs[index].reference.id;
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
                      String docID = snapshot.data!.docs[index].reference.id;
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
                        final String dateFormated = DateFormat('h:mm a').format(
                          DateTime.parse(
                            chatModel.dateString!,
                          ),
                        );
                        setMess(dateFormated,
                            '${chatModel.userName!} : ${chatModel.message!}');
                      }

                      String docID = snapshot.data!.docs[index].reference.id;
                      fun() {
                        priv.reply = const SizedBox();
                        priv.replied = false;
                        langCon.update();
                      }

                      return TextMessageFriend(
                        chatModel: chatModel,
                        myUid: myUid,
                        friendUid: friendUid,
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
                        myUid: myUid,
                        friendUid: friendUid,
                        fun: fun,
                      );
                    }
                  }
                  return const Text('');
                },
              ),
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width / 15,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
          return const Text('Null !!!!!');
        },
      ),
    );
  }
}
