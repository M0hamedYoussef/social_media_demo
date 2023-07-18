import 'dart:async';
import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/global/notify_con.dart';
import 'package:social_media_demo/controller/global/obx_con.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';

class ChatTextForm extends StatelessWidget {
  const ChatTextForm({super.key, required this.iconF, required this.myUid});
  final FocusNode iconF;
  final String myUid;
  @override
  Widget build(BuildContext context) {
    ScrollController textFieldScrollController = ScrollController();
    NotifyCon notifyCon = Get.put(NotifyCon());
    ObxCon obx = Get.put(ObxCon());
    LangCon langCon = Get.put(LangCon());
    PrivateChatsCon priv = Get.put(PrivateChatsCon());
    AppCon appCon = Get.find();

    return Row(
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 80),
            child: TextFormField(
              autocorrect: false,
              scrollController: textFieldScrollController,
              controller: obx.mess,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              focusNode: obx.f,
              textDirection: langCon.langTextField == 'en'
                  ? ui.TextDirection.ltr
                  : ui.TextDirection.rtl,
              onChanged: (val) async {
                textFieldScrollController
                    .jumpTo(textFieldScrollController.position.maxScrollExtent);
                if (val.trim().length == 1) {
                  langCon.checkTextLang(val);
                  langCon.update();
                }
                if (val.trim().isNotEmpty) {
                  WriteBatch batch = FirebaseFirestore.instance.batch();
                  batch.set(priv.myStatusInFriend!, {'status': 'Typing ...'});
                  await batch.commit();
                } else if (val.trim().isEmpty) {
                  WriteBatch batch = FirebaseFirestore.instance.batch();
                  batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                  await batch.commit();
                }
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                prefixIcon: IconButton(
                  focusNode: iconF,
                  onPressed: () {
                    obx.f.canRequestFocus = true;
                    obx.changeemojivis();
                    obx.f.unfocus();
                    obx.f.nextFocus();
                  },
                  icon: GetX<ObxCon>(
                    builder: (controller) => Icon(
                      obx.emoji.value == true
                          ? Icons.keyboard
                          : Icons.emoji_emotions_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () {
              Get.defaultDialog(
                title: 'Upload Media',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();
                            if (priv.replied == false) {
                              Get.back();
                              priv.reply = const SizedBox();
                              priv.replied = false;
                              langCon.update();
                              await priv.uploadImage();
                              notifyCon.sendNotification(
                                title: appCon.name!,
                                body: 'sent image',
                                token: priv.friendToken,
                                friendUid: myUid,
                                pfp: appCon.pfp!,
                                friendName: appCon.name!,
                              );
                              batch.set(priv.myStatusInFriend!,
                                  {'status': 'In Chat'});
                              await batch.commit();
                            } else if (priv.replied == true) {
                              Get.back();
                              priv.reply = const SizedBox();
                              priv.replied = false;
                              langCon.update();
                              await priv.uploadReplyImage(
                                repliedMessage: priv.repliedMess!,
                                repliedMessageID: priv.repliedMessID!,
                                repliedTO: priv.repliedTO!,
                                type: priv.toType!,
                                lang: priv.toLANG ?? '',
                              );
                              notifyCon.sendNotification(
                                title: appCon.name!,
                                body: 'sent image',
                                token: priv.friendToken,
                                friendUid: myUid,
                                pfp: appCon.pfp!,
                                friendName: appCon.name!,
                              );
                              batch.set(priv.myStatusInFriend!,
                                  {'status': 'In Chat'});
                              await batch.commit();
                            }
                          },
                          icon: const Icon(Icons.image),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        IconButton(
                          onPressed: () async {
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();

                            if (priv.replied == false) {
                              Get.back();
                              priv.reply = const SizedBox();
                              priv.replied = false;
                              langCon.update();
                              await priv.uploadVid();
                              notifyCon.sendNotification(
                                title: appCon.name!,
                                body: 'sent video',
                                token: priv.friendToken,
                                friendUid: myUid,
                                pfp: appCon.pfp!,
                                friendName: appCon.name!,
                              );

                              batch.set(priv.myStatusInFriend!,
                                  {'status': 'In Chat'});
                              await batch.commit();
                            } else if (priv.replied == true) {
                              Get.back();
                              priv.reply = const SizedBox();
                              priv.replied = false;
                              langCon.update();

                              await priv.uploadReplyVid(
                                repliedMessage: priv.repliedMess!,
                                repliedMessageID: priv.repliedMessID!,
                                repliedTO: priv.repliedTO!,
                                type: priv.toType!,
                                lang: priv.toLANG ?? '',
                              );

                              notifyCon.sendNotification(
                                title: appCon.name!,
                                body: 'sent video',
                                token: priv.friendToken,
                                friendUid: myUid,
                                pfp: appCon.pfp!,
                                friendName: appCon.name!,
                              );

                              batch.set(priv.myStatusInFriend!,
                                  {'status': 'In Chat'});
                              await batch.commit();
                            }
                          },
                          icon: const Icon(Icons.ondemand_video),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Image'),
                        SizedBox(
                          width: 55,
                        ),
                        Text('Video'),
                      ],
                    ),
                  ],
                ),
              );
            },
            child: const Icon(
              size: 25,
              Icons.perm_media,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () async {
              if (priv.replied == false) {
                priv.reply = const SizedBox();
                priv.replied = false;
                langCon.update();
                await priv.insertGif(appCon.name!, context);
                await notifyCon.sendNotification(
                  title: appCon.name!,
                  body: 'sent gif',
                  token: priv.friendToken,
                  friendUid: myUid,
                  pfp: appCon.pfp!,
                  friendName: appCon.name!,
                );
                Timer(
                  const Duration(milliseconds: 1500),
                  () async {
                    WriteBatch batch = FirebaseFirestore.instance.batch();

                    batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                    await batch.commit();
                  },
                );
              } else if (priv.replied == true) {
                priv.reply = const SizedBox();
                priv.replied = false;
                langCon.update();
                await priv.insertReplyGif(
                  appCon.name!,
                  context,
                  repliedMessage: priv.repliedMess!,
                  repliedMessageID: priv.repliedMessID!,
                  repliedTO: priv.repliedTO!,
                  type: priv.toType!,
                  lang: priv.toLANG ?? '',
                );
                notifyCon.sendNotification(
                  title: appCon.name!,
                  body: 'sent gif',
                  token: priv.friendToken,
                  friendUid: myUid,
                  pfp: appCon.pfp!,
                  friendName: appCon.name!,
                );
                Timer(
                  const Duration(milliseconds: 1500),
                  () async {
                    WriteBatch batch = FirebaseFirestore.instance.batch();

                    batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                    await batch.commit();
                  },
                );
              }
            },
            child: const Icon(
              size: 50,
              Icons.gif,
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            WriteBatch batch = FirebaseFirestore.instance.batch();
            if (obx.mess.text.trim().isNotEmpty && priv.replied == false) {
              String rawMess = obx.mess.text;
              obx.mess.clear();
              priv.sendMessage(
                myLANG: langCon.langTextField.toString(),
                username: appCon.name!,
                message: rawMess.trim(),
                userID: FirebaseAuth.instance.currentUser!.uid,
              );
              priv.reply = const SizedBox();
              priv.replied = false;
              langCon.update();
              notifyCon.sendNotification(
                title: appCon.name!,
                body: rawMess.trim(),
                token: priv.friendToken,
                friendUid: myUid,
                pfp: appCon.pfp!,
                friendName: appCon.name!,
              );
              batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
              batch.commit();
            } else if (obx.mess.text.trim().isNotEmpty &&
                priv.replied == true) {
              String rawMess = obx.mess.text;
              obx.mess.clear();
              priv.sendReply(
                myLANG: langCon.langTextField.toString(),
                type: priv.toType!,
                lang: priv.toLANG ?? '',
                repliedTO: priv.repliedTO!,
                repliedMessage: priv.repliedMess!,
                repliedMessageID: priv.repliedMessID!,
                username: appCon.name!,
                message: rawMess.trim(),
                userID: myUid,
              );
              priv.reply = const SizedBox();
              priv.replied = false;
              langCon.update();
              notifyCon.sendNotification(
                title: appCon.name!,
                body: rawMess.trim(),
                token: priv.friendToken,
                friendUid: myUid,
                pfp: appCon.pfp!,
                friendName: appCon.name!,
              );
              batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
              batch.commit();
            } else if (obx.mess.text.trim() == '') {
              obx.mess.clear();
              priv.replied = false;
              priv.reply = const SizedBox();
              langCon.update();
              batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
              batch.commit();
            }
          },
          icon: const Icon(
            size: 25,
            Icons.send,
          ),
        ),
      ],
    );
  }
}
