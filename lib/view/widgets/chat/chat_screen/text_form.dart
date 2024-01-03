import 'dart:async';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:sm_project/controller/chat/speed_dial_controller.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/controller/global/notify_con.dart';
import 'package:sm_project/controller/global/obx_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/const/image_asset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:ui' as ui;

class ChatTextForm extends StatelessWidget {
  const ChatTextForm({super.key, required this.iconF, required this.myUid});
  final FocusNode iconF;
  final String myUid;
  @override
  Widget build(BuildContext context) {
    ScrollController textFieldScrollController = ScrollController();
    ObxCon obx = Get.put(ObxCon());
    LangCon langCon = Get.put(LangCon());
    SpeedDialController speedDialController = Get.put(SpeedDialController());
    PrivateChatsCon priv = Get.put(PrivateChatsCon());
    NotifyCon notifyCon = Get.put(NotifyCon());
    AppCon appCon = Get.find();

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: SpeedDial(
            icon: Icons.add_rounded,
            activeIcon: Icons.close_rounded,
            openCloseDial: speedDialController.hideChatScreen,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            buttonSize: const Size.fromRadius(25),
            overlayOpacity: 0,
            backgroundColor: AppColors.darkBlue,
            children: [
              SpeedDialChild(
                backgroundColor: AppColors.darkBlue,
                child: IconButton(
                  onPressed: () async {
                    speedDialController.hideChatScreen.value =
                        !speedDialController.hideChatScreen.value;
                    WriteBatch batch = FirebaseFirestore.instance.batch();
                    if (priv.replied == false) {
                      priv.reply = const SizedBox();
                      priv.replied = false;
                      langCon.update();
                      await priv.uploadImage();
                      batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                      await batch.commit();
                    } else if (priv.replied == true) {
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
                      batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                      await batch.commit();
                    }
                  },
                  icon: const Icon(
                    Icons.image,
                    color: AppColors.white,
                  ),
                ),
              ),
              SpeedDialChild(
                backgroundColor: AppColors.darkBlue,
                child: IconButton(
                  onPressed: () async {
                    speedDialController.hideChatScreen.value =
                        !speedDialController.hideChatScreen.value;

                    WriteBatch batch = FirebaseFirestore.instance.batch();
                    if (priv.replied == false) {
                      priv.reply = const SizedBox();
                      priv.replied = false;
                      langCon.update();
                      await priv.uploadVid();
                      batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                      await batch.commit();
                    } else if (priv.replied == true) {
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

                      batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                      await batch.commit();
                    }
                  },
                  icon: const Icon(
                    Icons.ondemand_video,
                    color: AppColors.white,
                  ),
                ),
              ),
              SpeedDialChild(
                backgroundColor: AppColors.darkBlue,
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () async {
                    speedDialController.hideChatScreen.value =
                        !speedDialController.hideChatScreen.value;

                    if (priv.replied == false) {
                      priv.reply = const SizedBox();
                      priv.replied = false;
                      langCon.update();
                      await priv.insertGif(appCon.name!, context);

                      Timer(
                        const Duration(milliseconds: 1500),
                        () async {
                          WriteBatch batch = FirebaseFirestore.instance.batch();

                          batch.set(
                              priv.myStatusInFriend!, {'status': 'In Chat'});
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

                      Timer(
                        const Duration(milliseconds: 1500),
                        () async {
                          WriteBatch batch = FirebaseFirestore.instance.batch();

                          batch.set(
                              priv.myStatusInFriend!, {'status': 'In Chat'});
                          await batch.commit();
                        },
                      );
                    }
                  },
                  child: const Icon(
                    size: 50,
                    Icons.gif,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!priv.recording)
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 80),
              child: TextFormField(
                autocorrect: false,
                scrollController: textFieldScrollController,
                controller: obx.mess,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                focusNode: obx.textFormFocus,
                textDirection: langCon.langTextField == 'en'
                    ? ui.TextDirection.ltr
                    : ui.TextDirection.rtl,
                onChanged: (val) async {
                  textFieldScrollController.jumpTo(
                      textFieldScrollController.position.maxScrollExtent);

                  if (val.trim().length == 1 ||
                      (val.trim().contains('http') &&
                          langCon.langTextField != 'en') ||
                      (val.trim().contains('.com') &&
                          langCon.langTextField != 'en') ||
                      (val.trim().contains('.net') &&
                          langCon.langTextField != 'en') ||
                      (val.trim().contains('.org') &&
                          langCon.langTextField != 'en')) {
                    langCon.checkTextLang(val.trim());
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
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  hintText: 'Send Message',
                  prefixIcon: IconButton(
                    focusNode: iconF,
                    onPressed: () {
                      obx.changeemojivis();
                    },
                    icon: GetX<ObxCon>(
                      builder: (controller) => Icon(
                        obx.emoji.value == true
                            ? Icons.keyboard
                            : Icons.emoji_emotions_outlined,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (priv.recording)
          Expanded(
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                priv.cancelRecording();
                HapticFeedback.heavyImpact();
                langCon.update();
              },
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                constraints: const BoxConstraints(maxHeight: 80),
                child: const Text(
                  '<< Slide To Cancel',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onLongPress: () async {
              if (obx.mess.text.trim().isEmpty) {
                obx.textFormFocus.unfocus();
                PermissionStatus mic = await Permission.microphone.request();
                if (mic.isGranted) {
                  priv.startRecording();
                  HapticFeedback.heavyImpact();
                  langCon.update();
                }
              }
            },
            onTap: () async {
              if (priv.recording) {
                WriteBatch batch = FirebaseFirestore.instance.batch();
                if (priv.replied) {
                  priv.reply = const SizedBox();
                  langCon.update();
                  priv.replied = true;
                  await priv.stopRecording();
                  langCon.update();
                  notifyCon.sendNotification(
                    title: appCon.name!,
                    body: 'sent voice',
                    token: priv.friendToken,
                    friendUid: myUid,
                    pfp: appCon.pfp!,
                    friendName: appCon.name!,
                  );
                  batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                  batch.commit();
                } else {
                  await priv.stopRecording();
                  langCon.update();
                  notifyCon.sendNotification(
                    title: appCon.name!,
                    body: 'sent voice',
                    token: priv.friendToken,
                    friendUid: myUid,
                    pfp: appCon.pfp!,
                    friendName: appCon.name!,
                  );
                  batch.set(priv.myStatusInFriend!, {'status': 'In Chat'});
                  batch.commit();
                }
              } else {
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
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.darkBlue,
              ),
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(4),
              child: GetBuilder<PrivateChatsCon>(
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: priv.recording
                        ? const Icon(Icons.mic, color: AppColors.white)
                        : SvgPicture.asset(
                            AppImageAsset.sendIcon,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
