import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/view/screens/media/image/imagescreen.dart';
import 'package:social_media_demo/view/screens/media/video/videoscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

PrivateChatsCon _privateChatsCon = Get.put(PrivateChatsCon());
LangCon _langCon = Get.put(LangCon());

class AppCon {
  MyServices myServices = Get.find();
  String? name;
  String? pfp;
  String? friendToken;
  TextEditingController editCon = TextEditingController();
  ScrollController textFieldScrollController = ScrollController();

//////////////////////////////////////////

  getInfo() async {
    if (myServices.mySharedPrefs.getString('pfp') != null &&
        myServices.mySharedPrefs.getString('username') != null) {
      name = myServices.mySharedPrefs.getString('username');
      pfp = myServices.mySharedPrefs.getString('pfp');
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
            (value) => {
              // ignore: avoid_function_literals_in_foreach_calls
              value.docs.forEach(
                (element) async {
                  await myServices.mySharedPrefs
                      .setString('username', element.data()['UserName']);
                  await myServices.mySharedPrefs
                      .setString('pfp', element.data()['pfp']);
                  name = element.data()['UserName'];
                  pfp = element.data()['pfp'];
                },
              )
            },
          );
    }
  }

  messageOnLongTap({
    required bool isMe,
    required bool isPrivate,
    required String formatedString,
    required String dateFormated,
    required dynamic messageDIR,
    required String messID,
    required Function fun,
  }) {
    isMe ? editCon.text = formatedString : null;
    isMe
        ? Get.bottomSheet(
            backgroundColor: Colors.white,
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              fun();
                              Get.back();
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          const Text('Delete Message'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                cancel: MaterialButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Get.back();
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: 'Message Sent Date',
                                content: Text(dateFormated),
                              );
                            },
                            icon: const Icon(Icons.date_range),
                          ),
                          const Text('Message Date'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                              Get.defaultDialog(
                                title: 'Edit Message',
                                content: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 5),
                                      child: SizedBox(
                                        height: 77,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 80, maxWidth: 80),
                                          child: GetBuilder<LangCon>(
                                            builder: (controller) =>
                                                TextFormField(
                                              scrollController:
                                                  textFieldScrollController,
                                              maxLines: null,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              autofocus: true,
                                              controller: editCon,
                                              textDirection: editCon.text
                                                          .trim() !=
                                                      messageDIR
                                                  ? _langCon.langTextField ==
                                                          'en'
                                                      ? ui.TextDirection.ltr
                                                      : ui.TextDirection.rtl
                                                  : messageDIR,
                                              onChanged: (value) {
                                                if (value.trim().length == 1) {
                                                  _langCon.checkTextLang(
                                                      value.trim());
                                                  _langCon.update();
                                                }
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                ),
                                                label: const Text(
                                                  'Message',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                                hintText: "Enter Your Message",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 5),
                                      child: SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.black,
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (editCon.text
                                                .trim()
                                                .isNotEmpty) {
                                              Get.back();
                                              isPrivate
                                                  ? _privateChatsCon.editMess(
                                                      messID,
                                                      editCon.text.trim(),
                                                      _langCon.langTextField!,
                                                    )
                                                  : null;
                                            } else if (editCon.text
                                                .trim()
                                                .isEmpty) {
                                              Get.defaultDialog(
                                                content: const Text(
                                                    'Message Is Empty !!'),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Confirm',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          const Text('Edit Message'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Get.defaultDialog(
            cancel: MaterialButton(
              color: Colors.black,
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            title: 'Message Sent Date',
            content: Text(dateFormated),
          );
  }

//////////////////////////////////////////

  buildMessage(
    String dateMess,
    String messID,
    String myMESS,
    String pfpMess,
    String username,
    String message,
    bool isMe,
    bool isPrivate, {
    String? myUid,
    String? friendUid,
    required bool isReply,
    String? myLANG,
    Function? fun,
  }) {
    ui.TextDirection messageDIR = _langCon.langTextField == 'en'
        ? ui.TextDirection.ltr
        : ui.TextDirection.rtl;

    final dateFormated = DateFormat('y-M-d h:mm a').format(
      DateTime.parse(
        dateMess,
      ),
    );
    String multiLangMESS;
    myLANG != null
        ? multiLangMESS = myLANG == 'en' ? message : '\u202B' '$message'
        : multiLangMESS = message;

    List listedMessage = multiLangMESS.split(' ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Stack(
        children: [
          Padding(
            padding: isMe
                ? const EdgeInsets.all(0)
                : const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: GestureDetector(
              onLongPress: () {
                messageOnLongTap(
                  isMe: isMe,
                  isPrivate: isPrivate,
                  formatedString: multiLangMESS,
                  dateFormated: dateFormated,
                  messageDIR: messageDIR,
                  messID: messID,
                  fun: isMe ? fun! : () {},
                );
              },
              child: Column(
                children: [
                  isMe
                      ? const SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : isReply
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                              margin: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: Text(
                                username,
                                style: TextStyle(
                                  color: isMe ? Colors.black : Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                  Align(
                    alignment:
                        isMe ? Alignment.bottomRight : Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: isMe ? 64.0 : 40.0,
                        right: isMe ? 8.0 : 64.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: RichText(
                        textDirection: myLANG!.contains('en')
                            ? ui.TextDirection.ltr
                            : ui.TextDirection.rtl,
                        text: TextSpan(
                          children: [
                            ...List.generate(
                              listedMessage.length,
                              (index) {
                                if (listedMessage[index].contains('http')) {
                                  return TextSpan(
                                    text: listedMessage[index] + ' ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await launchUrl(
                                          Uri.parse(listedMessage[index]),
                                          mode: LaunchMode.inAppWebView,
                                        );
                                      },
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 16.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  );
                                } else if (listedMessage[index]
                                        .contains('.com') ||
                                    listedMessage[index].contains('.net') ||
                                    listedMessage[index].contains('.org')) {
                                  return TextSpan(
                                    text: listedMessage[index] + ' ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await launchUrl(
                                          Uri.parse(
                                              'http:${listedMessage[index]}'),
                                          mode: LaunchMode.inAppWebView,
                                        );
                                      },
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 16.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  );
                                } else {
                                  return TextSpan(
                                    text: listedMessage[index] + ' ',
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isMe
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : Container(
                  margin: isReply
                      ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: CachedNetworkImageProvider(pfpMess),
                  ),
                ),
        ],
      ),
    );
  }

//////////////////////////////////////////

  loadingImageContainer(
      {required bool isMe, required String username, required String pfp}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        isMe
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Row(
                textDirection:
                    isMe ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 5, 15, 0),
                    color: Colors.transparent,
                    child: Text(
                      username,
                      style: TextStyle(
                        color: isMe ? Colors.black : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe
                ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    height: 170,
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: CachedNetworkImageProvider(pfp),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                width: 330,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: isMe ? 64.0 : 8.0,
                      right: isMe ? 8.0 : 64.0,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.black,
                        width: 80,
                        height: 160,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildImage(String sentDate, String pfpImg, String username, String url,
      bool isMe, bool isReplay, String path,
      {var fun, bool isToTextReplay = false}) {
    final dateFormat = DateFormat('y-M-d h:mm a');
    final dateFormated = dateFormat.format(
      DateTime.parse(
        sentDate,
      ),
    );

    return Stack(
      children: [
        isMe
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(pfpImg),
                ),
              ),
        Padding(
          padding: isMe
              ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
              : const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMe
                  ? const SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : isReplay
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                          color: Colors.transparent,
                          child: Text(
                            username,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => ImageScreen(
                      url: url,
                      heroTag: url,
                    ),
                    transition: Transition.downToUp,
                  );
                },
                onLongPress: () {
                  isMe
                      ? Get.bottomSheet(
                          backgroundColor: Colors.white,
                          SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                              cancel: MaterialButton(
                                                color: Colors.black,
                                                onPressed: () {
                                                  Get.back();
                                                  Get.back();
                                                },
                                                child: const Text(
                                                  'Back',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              title: 'Message Sent Date',
                                              content: Text(dateFormated),
                                            );
                                          },
                                          icon: const Icon(Icons.date_range),
                                        ),
                                        const Text('Message Date'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            fun();
                                            Get.back();
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                        const Text(
                                          'Delete Image',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Get.defaultDialog(
                          cancel: MaterialButton(
                            color: Colors.black,
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: 'Message Sent Date',
                          content: Text(dateFormated),
                        );
                },
                child: Align(
                  child: Container(
                    width: 240,
                    margin: EdgeInsets.only(
                      top: isToTextReplay ? 0 : 8,
                      bottom: 8.0,
                      left: isMe ? 120.0 : 8.0,
                      right: isMe ? 0 : 64.0,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            placeholder: (context, url) {
                              return const SizedBox();
                            },
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//////////////////////////////////////////

  loadingVideoContainer(
      {required bool isMe, required String username, required String pfp}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        isMe
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Row(
                textDirection:
                    isMe ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 5, 15, 0),
                    color: Colors.transparent,
                    child: Text(
                      username,
                      style: TextStyle(
                        color: isMe ? Colors.black : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe
                ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    height: 170,
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: CachedNetworkImageProvider(pfp),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                width: 330,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: isMe ? 64.0 : 8.0,
                      right: isMe ? 8.0 : 64.0,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.black,
                        width: 80,
                        height: 160,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  biuldVid(String sentDate, String pfpVid, String username, String url,
      String vidthumburl, bool isMe, BuildContext context,
      {var fun, bool isReplay = false}) {
    final dateFormat = DateFormat('y-M-d h:mm a');
    final dateFormated = dateFormat.format(
      DateTime.parse(
        sentDate,
      ),
    );
    return Stack(
      children: [
        isMe
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(pfpVid),
                ),
              ),
        Padding(
          padding: isMe
              ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
              : const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMe
                  ? const SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : isReplay
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                          color: Colors.transparent,
                          child: Text(
                            username,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
              Align(
                alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Container(
                  width: 240,
                  margin: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent.withOpacity(0),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onLongPress: () {
                      isMe
                          ? Get.bottomSheet(
                              backgroundColor: Colors.white,
                              SizedBox(
                                height: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Get.defaultDialog(
                                                  cancel: MaterialButton(
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      Get.back();
                                                      Get.back();
                                                    },
                                                    child: const Text(
                                                      'Back',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  title: 'Message Sent Date',
                                                  content: Text(dateFormated),
                                                );
                                              },
                                              icon:
                                                  const Icon(Icons.date_range),
                                            ),
                                            const Text('Message Date'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                fun();
                                                Get.back();
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                            const Text('Delete Message'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Get.defaultDialog(
                              cancel: MaterialButton(
                                color: Colors.black,
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: 'Message Sent Date',
                              content: Text(dateFormated),
                            );
                    },
                    onTap: () {
                      Get.to(
                        () => const VideoScreen(),
                        transition: Transition.downToUp,
                        arguments: {
                          'url': url,
                        },
                      );
                    },
                    child: Align(
                      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: isMe
                                ? const EdgeInsets.fromLTRB(0, 0, 8, 0)
                                : const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Align(
                              alignment: isMe
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: vidthumburl,
                                      key: ValueKey(vidthumburl),
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.6),
                                          spreadRadius: -2,
                                          blurRadius: 0,
                                          offset: const Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isMe
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(pfpVid),
                ),
              ),
      ],
    );
  }

  replyMess(
    String username,
    String message,
    Function fun, {
    String? myLANG,
  }) {
    String correctMess = '';
    myLANG != null
        ? correctMess = myLANG == 'en' ? message : '\u202B' '$message'
        : correctMess = message;
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    fun();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Text(
              correctMess,
              textDirection: _langCon.checkMessegeLang(message) == 'en'
                  ? ui.TextDirection.ltr
                  : ui.TextDirection.rtl,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  replyIMG(
    String username,
    String img,
    Function fun,
  ) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    fun();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 50,
              child: CachedNetworkImage(
                imageUrl: img,
                placeholder: (context, url) {
                  return const SizedBox();
                },
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }

  buildReplyMess(
    String theUser,
    String repliedTO,
    String repliedMess,
    bool isMe, {
    String? myLANG,
  }) {
    String correctRepMess = '';
    myLANG != null
        ? correctRepMess =
            myLANG == 'en' ? repliedMess : '\u202B' '$repliedMess'
        : correctRepMess = repliedMess;
    return Column(
      children: [
        isMe
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                margin: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Text(
                  '${theUser[0].capitalize}${theUser.substring(1, theUser.length)} Replied To ${repliedTO[0].capitalize}${repliedTO.substring(1, repliedTO.length)}',
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
        Align(
          alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(
              left: isMe ? 64.0 : 40.0,
              right: isMe ? 8.0 : 64.0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Opacity(
              opacity: 0.75,
              child: Text(
                correctRepMess,
                textDirection: _langCon.checkMessegeLang(repliedMess) == 'en'
                    ? ui.TextDirection.ltr
                    : ui.TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildReplyImage(
    String theUser,
    String repliedTO,
    String repliedImgLink,
    bool isMe,
  ) {
    return Column(
      children: [
        isMe
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                margin: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Text(
                  '${theUser[0].capitalize}${theUser.substring(1, theUser.length)} Replied To ${repliedTO[0].capitalize}${repliedTO.substring(1, repliedTO.length)}',
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
        Align(
          alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(
              left: isMe ? 64.0 : 40.0,
              right: isMe ? 8.0 : 64.0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: repliedImgLink,
                  placeholder: (context, url) {
                    return const SizedBox();
                  },
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
