import 'dart:io';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/controller/global/notify_con.dart';
import 'package:sm_project/core/const/api_keys.dart';
import 'package:sm_project/core/services/my_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

AppCon _appCon = Get.put(AppCon());
NotifyCon _notifyCon = Get.put(NotifyCon());

class PrivateChatsCon extends GetxController {
  @override
  onInit() {
    super.onInit();
    initChat();
    audioPlayer.durationStream.listen((event) {
      if (event != null) {
        audioDuration = double.parse(event.inMicroseconds.toString());
        update();
      }
    });
    audioPlayer.positionStream.listen((event) {
      if (audioPosition != audioDuration) {
        audioPosition = double.parse(event.inMicroseconds.toString());
        update();
      }
    });
    audioPlayer.playerStateStream.listen(
      (event) async {
        if (event.processingState == ProcessingState.completed) {
          await audioPlayer.stop();
          audioPosition = 0;
          audioDuration = 0;
          currentRecordId = '';
          update();
        }
      },
    );
  }

  MyServices myServices = Get.find();
  Widget reply = const SizedBox();
  bool replied = false;
  String? toLANG;
  String? repliedTO;
  String? repliedMess;
  String? toType;
  int? repliedMessID;
  String? imageUrl;
  String? vidUrl;
  File? image;
  File? vid;
  int? rand;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  late String friendUid;
  late String friendName;
  late String friendPFP;
  late String friendToken;

  FocusNode iconF = FocusNode();
  CollectionReference<Map<String, dynamic>>? privatemessagesME;
  CollectionReference<Map<String, dynamic>>? privatemessagesFriend;
  DocumentReference<Map<String, dynamic>>? friendStatusInMY;
  DocumentReference<Map<String, dynamic>>? myStatusInFriend;

  AudioRecorder audioRecorder = AudioRecorder();
  AudioPlayer audioPlayer = AudioPlayer();
  late Directory tempPath;
  late String currentAudioPath;
  bool recording = false;
  String currentRecordId = '';
  double audioDuration = 0;
  double audioPosition = 0;

  initChat() async {
    friendUid = Get.arguments['friendUid'];
    friendName = Get.arguments['friendName'];
    friendPFP = Get.arguments['friendPFP'];
    friendToken = Get.arguments['friendToken'];
    AppCon appCon = Get.find();
    appCon.friendToken = friendToken;
    Get.put(LangCon());
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    privatemessagesME = FirebaseFirestore.instance
        .collection('message/privates/$myUid/$friendUid/messages');
    privatemessagesFriend = FirebaseFirestore.instance
        .collection('message/privates/$friendUid/$myUid/messages');
    Get.put(NotifyCon());
    friendUid = friendUid;
    myStatusInFriend = privatemessagesFriend!.doc('STATUS$myUid');
    friendStatusInMY = privatemessagesME!.doc('STATUS$friendUid');
    setInCHAT();
    tempPath = await getTemporaryDirectory();
    currentAudioPath = '${tempPath.path}/current.mp3';
  }

  setOutOfChat() async {
    myStatusInFriend!.set({'status': ''});
  }

  setInCHAT() async {
    await myStatusInFriend!.set({'status': 'In Chat'});
  }

  deleteLast() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: myUid)
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          String myDocID = element.reference.id;
          FirebaseFirestore.instance.collection('users').doc(myDocID).update(
            {
              'lastmess': {
                '$myUid$friendUid': '',
                '$friendUid$myUid': '',
              },
              'lastdate': {
                '$myUid$friendUid': '',
                '$friendUid$myUid': '',
              },
            },
          );
        }
      },
    );
    await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: friendUid)
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          String myDocID = element.reference.id;
          FirebaseFirestore.instance.collection('users').doc(myDocID).update(
            {
              'lastmess': {
                '$myUid$friendUid': '',
                '$friendUid$myUid': '',
              },
              'lastdate': {
                '$myUid$friendUid': '',
                '$friendUid$myUid': '',
              },
            },
          );
        }
      },
    );
  }

  setMess(date, mess) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: myUid)
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          String myDocID = element.reference.id;
          FirebaseFirestore.instance.collection('users').doc(myDocID).update(
            {
              'lastmess': {
                '$myUid$friendUid': '$mess',
                '$friendUid$myUid': '$mess',
              },
              'lastdate': {
                '$myUid$friendUid': '$date',
                '$friendUid$myUid': '$date',
              },
            },
          );
        }
      },
    );
    await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: friendUid)
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          String myDocID = element.reference.id;
          FirebaseFirestore.instance.collection('users').doc(myDocID).update(
            {
              'lastmess': {
                // '$myUid$friendUid': '$mess',
                '$friendUid$myUid': '$mess',
              },
              'lastdate': {
                // '$myUid$friendUid': '$date',
                '$friendUid$myUid': '$date',
              },
            },
          );
        }
      },
    );
  }

  countedMessages() {
    int i = 0;
    privatemessagesME!.get().then(
          (value) => i = value.size,
        );
    return i;
  }

  sendMessage({
    String? message,
    required String myLANG,
    String? userID,
    String? username,
    String? image,
    String? imagepath,
    String? ref,
    String? vid,
    String? vidpath,
    String? vidthumbpath,
    String? vidthumb,
    bool? isVidUploaded,
    bool? isImgUploaded,
  }) {
    int rand0 = Random().nextInt(100000000);
    int rand1 = Random().nextInt(100000000);
    int rand2 = Random().nextInt(100000000);

    privatemessagesME!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'pfp': _appCon.pfp,
        'UserID': userID,
        'username': username,
        'messageID': rand0 + rand1 + rand2,
        'message': message,
        'messLANG': myLANG,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imgID': rand0 + rand1 + rand2,
        'imagepath': imagepath.toString(),
        'vid': vid,
        'reply': false,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );

    privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'pfp': _appCon.pfp,
        'username': username,
        'message': message,
        'messLANG': myLANG,
        'messageID': rand0 + rand1 + rand2,
        'UserID': userID,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imagepath': imagepath.toString(),
        'imgID': rand0 + rand1 + rand2,
        'vid': vid,
        'reply': false,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );
  }

  sendReply({
    required String repliedTO,
    required String repliedMessage,
    required int repliedMessageID,
    required String lang,
    required String type,
    ////////////////////////
    String? message,
    required String myLANG,
    String? userID,
    String? username,
    String? image,
    String? imagepath,
    String? ref,
    String? vid,
    String? vidpath,
    String? vidthumbpath,
    String? vidthumb,
    bool? isVidUploaded,
    bool? isImgUploaded,
  }) async {
    int rand0 = Random().nextInt(100000000);
    int rand1 = Random().nextInt(100000000);
    int rand2 = Random().nextInt(100000000);
    privatemessagesME!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'pfp': _appCon.pfp,
        'username': username,
        'message': message,
        'messLANG': myLANG,
        'ToLang': lang,
        'messageID': rand0 + rand1 + rand2,
        'imgID': rand0 + rand1 + rand2,
        'UserID': userID,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imagepath': imagepath.toString(),
        'vid': vid,
        'reply': true,
        'repliedTO': repliedTO,
        'repliedImg': repliedMessage,
        'repliedMess': repliedMessage,
        'repliedVid': repliedMessage,
        'repliedMessID': repliedMessageID,
        'ToType': type,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );

    privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'pfp': _appCon.pfp,
        'username': username,
        'imgID': rand0 + rand1 + rand2,
        'message': message,
        'messLANG': myLANG,
        'messageID': rand0 + rand1 + rand2,
        'UserID': userID,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imagepath': imagepath.toString(),
        'vid': vid,
        'reply': true,
        'repliedTO': repliedTO,
        'ToLang': lang,
        'repliedImg': repliedMessage,
        'repliedMess': repliedMessage,
        'repliedVid': repliedMessage,
        'repliedMessID': repliedMessageID,
        'ToType': type,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );
  }

  editMess(String iD, String message, String messLang) {
    privatemessagesME!.doc(iD).update(
      {
        'message': message,
        'messLANG': messLang,
      },
    );
    privatemessagesFriend!.doc(iD).update(
      {
        'message': message,
        'messLANG': messLang,
      },
    );
  }

  Future insertGif(String username, BuildContext context) async {
    final gif = await GiphyPicker.pickGif(
      fullScreenDialog: true,
      context: context,
      apiKey: ApiKeys.gifApiKey,
      rating: GiphyRating.r,
      lang: GiphyLanguage.english,
    );
    if (gif != null) {
      myStatusInFriend!.set({'status': 'Sending Gif'});
      await _notifyCon.sendNotification(
        title: _appCon.name!,
        body: 'sent gif',
        token: friendToken,
        friendUid: myUid,
        pfp: _appCon.pfp!,
        friendName: _appCon.name!,
      );
      sendMessage(
        myLANG: null.toString(),
        username: username,
        userID: myUid,
        image: gif.images.original!.url,
        isImgUploaded: true,
      );
    }
  }

  Future insertReplyGif(
    String username,
    BuildContext context, {
    required String repliedTO,
    required String repliedMessage,
    required int repliedMessageID,
    required String type,
    required String lang,
  }) async {
    final gif = await GiphyPicker.pickGif(
      fullScreenDialog: true,
      sticker: false,
      context: context,
      apiKey: ApiKeys.gifApiKey,
      rating: GiphyRating.r,
      lang: GiphyLanguage.english,
    );
    if (gif != null) {
      myStatusInFriend!.set({'status': 'Sending Gif'});
      await _notifyCon.sendNotification(
        title: _appCon.name!,
        body: 'sent gif',
        token: friendToken,
        friendUid: myUid,
        pfp: _appCon.pfp!,
        friendName: _appCon.name!,
      );
      sendReply(
        myLANG: null.toString(),
        username: username,
        userID: myUid,
        image: gif.images.original!.url,
        isImgUploaded: true,
        repliedMessage: repliedMessage,
        repliedMessageID: repliedMessageID,
        repliedTO: repliedTO,
        type: type,
        lang: lang,
      );
    }
  }

  deleteMessage({required String messageID}) {
    privatemessagesME!.doc(messageID).delete();
    privatemessagesFriend!.doc(messageID).delete();
  }

  uploadVid() async {
    Reference? storageref;
    XFile? pickedvid =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedvid != null) {
      myStatusInFriend!.set({'status': 'Sending Video'});
      String vidName = basename(pickedvid.path);

      vid = File(pickedvid.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('videos/$rand$vidName');
      Reference refThumb = FirebaseStorage.instance.ref('thumbnails/$rand');
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);

      privatemessagesME!.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': myUid,
          'username': _appCon.name,
          'vidID': rand0 + rand1,
          'isVidUploaded': false,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'message': null,
          'reply': false,
          'image': null,
          'imagepath': null,
          'vid': null,
          'vidname': vidName,
          'vidthumb': null,
          'vidpath': null,
          'storageref': null,
          'isImgUploaded': null,
        },
      );

      privatemessagesFriend!.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': myUid,
          'username': _appCon.name,
          'isVidUploaded': false,
          'vidID': rand0 + rand1,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'message': null,
          'reply': false,
          'image': null,
          'imagepath': null,
          'vid': null,
          'vidname': vidName,
          'vidthumb': null,
          'vidpath': null,
          'storageref': null,
          'isImgUploaded': null,
        },
      );
      _notifyCon.sendNotification(
        title: _appCon.name!,
        body: 'sent video',
        token: friendToken,
        friendUid: myUid,
        pfp: _appCon.pfp!,
        friendName: _appCon.name!,
      );
//
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: pickedvid.path,
        thumbnailPath: (await getExternalStorageDirectory())?.path,
        imageFormat: ImageFormat.WEBP,
        quality: 100,
      );
//
      await storageref.putFile(vid!);
      await refThumb.putFile(File(thumbnail!));
//
      vidUrl = await storageref.getDownloadURL();
      String vidthumblink = await refThumb.getDownloadURL();

//
      privatemessagesME!.doc('$rand0$rand1').update(
        {
          'vid': vidUrl,
          'vidpath': pickedvid.path,
          'vidthumbpath': thumbnail,
          'vidthumb': vidthumblink,
          'storageref_vid': storageref.fullPath.toString(),
          'storageref_thumb': refThumb.fullPath.toString(),
          'isVidUploaded': true,
        },
      );

      privatemessagesFriend!.doc('$rand0$rand1').update(
        {
          'vid': vidUrl,
          'vidpath': pickedvid.path,
          'vidthumbpath': thumbnail,
          'vidthumb': vidthumblink,
          'storageref_vid': storageref.fullPath.toString(),
          'storageref_thumb': refThumb.fullPath.toString(),
          'isVidUploaded': true,
        },
      );
    }
  }

  uploadImage() async {
    Reference? storageref;
    List<XFile>? pickedimage = await ImagePicker().pickMultiImage();
    if (pickedimage.isNotEmpty) {
      myStatusInFriend!.set({'status': 'Sending Image'});

      for (int i = 0; i < pickedimage.length;) {
        String imageName = basename(pickedimage[i].path);

        image = File(pickedimage[i].path);
        rand = Random().nextInt(1000000000);
        storageref = FirebaseStorage.instance.ref('images/$rand$imageName');
        int rand0 = Random().nextInt(1000000000);
        int rand1 = Random().nextInt(1000000000);
        await privatemessagesME!.doc('$rand0$rand1').set(
          {
            'pfp': _appCon.pfp,
            'UserID': myUid,
            'username': _appCon.name,
            'date': DateTime.now(),
            'dateSTRING': DateTime.now().toString(),
            'isImgUploaded': false,
            'message': null,
            'reply': false,
            'image': null,
            'imgID': rand0 + rand1,
            'imagepath': null,
            'vid': null,
            'vidpath': null,
            'storageref': null,
            'isVidUploaded': null,
          },
        );
        await privatemessagesFriend!.doc('$rand0$rand1').set(
          {
            'pfp': _appCon.pfp,
            'UserID': myUid,
            'username': _appCon.name,
            'date': DateTime.now(),
            'dateSTRING': DateTime.now().toString(),
            'isImgUploaded': false,
            'message': null,
            'image': null,
            'reply': false,
            'imgID': rand0 + rand1,
            'imagepath': null,
            'vid': null,
            'vidpath': null,
            'storageref': null,
            'isVidUploaded': null,
          },
        );
        _notifyCon.sendNotification(
          title: _appCon.name!,
          body: 'sent image',
          token: friendToken,
          friendUid: myUid,
          pfp: _appCon.pfp!,
          friendName: _appCon.name!,
        );

        await storageref.putFile(image!);

        imageUrl = await storageref.getDownloadURL().then(
          (value) async {
            await privatemessagesME!.doc('$rand0$rand1').update(
              {
                'image': value,
                'imagepath': pickedimage[i].path,
                'storageref': storageref!.fullPath.toString(),
                'isImgUploaded': true,
              },
            );
            await privatemessagesFriend!.doc('$rand0$rand1').update(
              {
                'image': value,
                'imagepath': pickedimage[i].path,
                'storageref': storageref.fullPath.toString(),
                'isImgUploaded': true,
              },
            );
            i++;

            return null;
          },
        );
      }
    }
  }

  uploadReplyImage({
    required String repliedTO,
    required String repliedMessage,
    required int repliedMessageID,
    required String lang,
    required String type,
  }) async {
    Reference? storageref;

    List<XFile>? pickedimage = await ImagePicker().pickMultiImage();

    if (pickedimage.isNotEmpty) {
      myStatusInFriend!.set({'status': 'Sending Image'});

      for (int i = 0; i < pickedimage.length;) {
        String imageName = basename(pickedimage[i].path);

        image = File(pickedimage[i].path);
        rand = Random().nextInt(1000000000);
        storageref = FirebaseStorage.instance.ref('images/$rand$imageName');
        int rand0 = Random().nextInt(1000000000);
        int rand1 = Random().nextInt(1000000000);
        await privatemessagesME!.doc('$rand0$rand1').set(
          {
            'pfp': _appCon.pfp,
            'UserID': myUid,
            'username': _appCon.name,
            'date': DateTime.now(),
            'dateSTRING': DateTime.now().toString(),
            'isImgUploaded': false,
            'message': null,
            'reply': true,
            'repliedTO': repliedTO,
            'repliedImg': repliedMessage,
            'repliedVid': repliedMessage,
            'repliedMessID': repliedMessageID,
            'ToType': type,
            'ToLang': lang,
            'image': null,
            'imgID': rand0 + rand1,
            'imagepath': null,
            'vid': null,
            'vidpath': null,
            'storageref': null,
            'isVidUploaded': null,
          },
        );
        await privatemessagesFriend!.doc('$rand0$rand1').set(
          {
            'pfp': _appCon.pfp,
            'UserID': myUid,
            'username': _appCon.name,
            'date': DateTime.now(),
            'dateSTRING': DateTime.now().toString(),
            'isImgUploaded': false,
            'message': null,
            'image': null,
            'reply': true,
            'repliedTO': repliedTO,
            'repliedImg': repliedMessage,
            'repliedVid': repliedMessage,
            'repliedMessID': repliedMessageID,
            'ToType': type,
            'ToLang': lang,
            'imgID': rand0 + rand1,
            'imagepath': null,
            'vid': null,
            'vidpath': null,
            'storageref': null,
            'isVidUploaded': null,
          },
        );
        _notifyCon.sendNotification(
          title: _appCon.name!,
          body: 'sent image',
          token: friendToken,
          friendUid: myUid,
          pfp: _appCon.pfp!,
          friendName: _appCon.name!,
        );

        await storageref.putFile(image!);

        imageUrl = await storageref.getDownloadURL().then(
          (value) async {
            await privatemessagesME!.doc('$rand0$rand1').update(
              {
                'image': value,
                'imagepath': pickedimage[i].path,
                'storageref': storageref!.fullPath.toString(),
                'isImgUploaded': true,
              },
            );
            await privatemessagesFriend!.doc('$rand0$rand1').update(
              {
                'image': value,
                'imagepath': pickedimage[i].path,
                'storageref': storageref.fullPath.toString(),
                'isImgUploaded': true,
              },
            );
            i++;
            return null;
          },
        );
      }
    }
  }

  uploadReplyVid({
    required String repliedTO,
    required String repliedMessage,
    required int repliedMessageID,
    required String lang,
    required String type,
  }) async {
    Reference? storageref;
    XFile? pickedvid =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedvid != null) {
      myStatusInFriend!.set({'status': 'Sending Video'});

      String vidName = basename(pickedvid.path);

      vid = File(pickedvid.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('videos/$rand$vidName');
      Reference refThumb = FirebaseStorage.instance.ref('thumbnails/$rand');
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);
      privatemessagesME!.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': myUid,
          'username': _appCon.name,
          'vidID': rand0 + rand1,
          'isVidUploaded': false,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'message': null,
          'reply': true,
          'repliedTO': repliedTO,
          'repliedImg': repliedMessage,
          'repliedVid': repliedMessage,
          'repliedMessID': repliedMessageID,
          'ToType': type,
          'ToLang': lang,
          'image': null,
          'imagepath': null,
          'vid': null,
          'vidname': vidName,
          'vidthumb': null,
          'vidpath': null,
          'storageref': null,
          'isImgUploaded': null,
        },
      );

      privatemessagesFriend!.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': myUid,
          'username': _appCon.name,
          'isVidUploaded': false,
          'vidID': rand0 + rand1,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'message': null,
          'reply': true,
          'repliedTO': repliedTO,
          'repliedImg': repliedMessage,
          'repliedVid': repliedMessage,
          'repliedMessID': repliedMessageID,
          'ToType': type,
          'ToLang': lang,
          'image': null,
          'imagepath': null,
          'vid': null,
          'vidname': vidName,
          'vidthumb': null,
          'vidpath': null,
          'storageref': null,
          'isImgUploaded': null,
        },
      );

      _notifyCon.sendNotification(
        title: _appCon.name!,
        body: 'sent video',
        token: friendToken,
        friendUid: myUid,
        pfp: _appCon.pfp!,
        friendName: _appCon.name!,
      );

//
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: pickedvid.path,
        thumbnailPath: (await getExternalStorageDirectory())?.path,
        imageFormat: ImageFormat.WEBP,
        quality: 100,
      );
//
      await storageref.putFile(vid!);
      await refThumb.putFile(File(thumbnail!));
//
      vidUrl = await storageref.getDownloadURL();
      String vidthumblink = await refThumb.getDownloadURL();

//
      privatemessagesME!.doc('$rand0$rand1').update(
        {
          'vid': vidUrl,
          'vidpath': pickedvid.path,
          'vidthumbpath': thumbnail,
          'vidthumb': vidthumblink,
          'storageref_vid': storageref.fullPath.toString(),
          'storageref_thumb': refThumb.fullPath.toString(),
          'isVidUploaded': true,
        },
      );

      privatemessagesFriend!.doc('$rand0$rand1').update(
        {
          'vid': vidUrl,
          'vidpath': pickedvid.path,
          'vidthumbpath': thumbnail,
          'vidthumb': vidthumblink,
          'storageref_vid': storageref.fullPath.toString(),
          'storageref_thumb': refThumb.fullPath.toString(),
          'isVidUploaded': true,
        },
      );
    }
  }

  uploadVoice({
    required Duration duration,
    String? message,
    String? myLANG,
    String? userID,
    String? username,
    String? image,
    String? imagepath,
    String? ref,
    String? vid,
    String? vidpath,
    String? vidthumbpath,
    String? vidthumb,
    bool? isVidUploaded,
    bool? isImgUploaded,
  }) async {
    int rand0 = Random().nextInt(100000000);
    int rand1 = Random().nextInt(100000000);
    int rand2 = Random().nextInt(100000000);

    File audioFile = File(currentAudioPath);
    Reference storageref =
        FirebaseStorage.instance.ref('voices/${rand0}current.mp3');

    privatemessagesME!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'voice': null,
        'duration': duration.toString(),
        'isVoiceUploaded': false,
        'pfp': _appCon.pfp,
        'username': _appCon.name,
        'UserID': myUid,
        'messageID': rand0 + rand1 + rand2,
        'message': message,
        'messLANG': myLANG,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imgID': rand0 + rand1 + rand2,
        'imagepath': imagepath.toString(),
        'vid': vid,
        'reply': false,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );

    privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'pfp': _appCon.pfp,
        'username': _appCon.name,
        'message': message,
        'messLANG': myLANG,
        'voice': null,
        'duration': duration.toString(),
        'isVoiceUploaded': false,
        'messageID': rand0 + rand1 + rand2,
        'UserID': myUid,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imagepath': imagepath.toString(),
        'imgID': rand0 + rand1 + rand2,
        'vid': vid,
        'reply': false,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );

    await storageref.putFile(audioFile);

    await storageref.getDownloadURL().then(
      (value) {
        privatemessagesME!.doc((rand0 + rand1 + rand2).toString()).update(
          {
            'voice': value,
            'storageref': storageref.fullPath.toString(),
            'isVoiceUploaded': true,
          },
        );

        privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()).update(
          {
            'voice': value,
            'storageref': storageref.fullPath.toString(),
            'isVoiceUploaded': true,
          },
        );
      },
    );
  }

  uploadReplyVoice({
    required Duration duration,
    required String repliedTO,
    required String repliedMessage,
    required int repliedMessageID,
    required String lang,
    required String type,
    String? message,
    String? myLANG,
    String? userID,
    String? username,
    String? image,
    String? imagepath,
    String? ref,
    String? vid,
    String? vidpath,
    String? vidthumbpath,
    String? vidthumb,
    bool? isVidUploaded,
    bool? isImgUploaded,
  }) async {
    int rand0 = Random().nextInt(100000000);
    int rand1 = Random().nextInt(100000000);
    int rand2 = Random().nextInt(100000000);

    File audioFile = File(currentAudioPath);
    Reference storageref =
        FirebaseStorage.instance.ref('voices/${rand0}current.mp3');

    privatemessagesME!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'voice': null,
        'reply': true,
        'repliedTO': repliedTO,
        'repliedImg': repliedMessage,
        'repliedMess': repliedMessage,
        'repliedVid': repliedMessage,
        'repliedMessID': repliedMessageID,
        'ToType': type,
        'duration': duration.toString(),
        'isVoiceUploaded': false,
        'pfp': _appCon.pfp,
        'username': _appCon.name,
        'UserID': myUid,
        'messageID': rand0 + rand1 + rand2,
        'message': message,
        'messLANG': myLANG,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imgID': rand0 + rand1 + rand2,
        'imagepath': imagepath.toString(),
        'vid': vid,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );

    privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()).set(
      {
        'pfp': _appCon.pfp,
        'username': _appCon.name,
        'message': message,
        'messLANG': myLANG,
        'voice': null,
        'duration': duration.toString(),
        'isVoiceUploaded': false,
        'messageID': rand0 + rand1 + rand2,
        'UserID': myUid,
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'image': image,
        'imagepath': imagepath.toString(),
        'imgID': rand0 + rand1 + rand2,
        'vid': vid,
        'reply': true,
        'repliedTO': repliedTO,
        'repliedImg': repliedMessage,
        'repliedMess': repliedMessage,
        'repliedVid': repliedMessage,
        'repliedMessID': repliedMessageID,
        'ToType': type,
        'vidpath': vidpath,
        'vidthumbpath': vidthumbpath,
        'vidthumb': vidthumb,
        'storageref': ref,
        'isVidUploaded': isVidUploaded,
        'isImgUploaded': isImgUploaded,
      },
    );

    await storageref.putFile(audioFile);

    await storageref.getDownloadURL().then(
      (value) {
        privatemessagesME!.doc((rand0 + rand1 + rand2).toString()).update(
          {
            'voice': value,
            'storageref': storageref.fullPath.toString(),
            'isVoiceUploaded': true,
          },
        );

        privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()).update(
          {
            'voice': value,
            'storageref': storageref.fullPath.toString(),
            'isVoiceUploaded': true,
          },
        );
      },
    );
  }

  startRecording() async {
    recording = true;
    update();
    await myStatusInFriend!.set({'status': 'Recording'});
    await audioRecorder.start(const RecordConfig(), path: currentAudioPath);
  }

  cancelRecording() async {
    recording = false;
    update();
    await audioRecorder.stop();
  }

  stopRecording() async {
    bool savedRep = replied;
    recording = false;
    update();
    await audioRecorder.stop();
    await audioPlayer.setFilePath(currentAudioPath);
    Duration recordDuration = audioPlayer.duration ?? Duration.zero;
    if (savedRep) {
      replied = false;
      uploadReplyVoice(
        duration: recordDuration,
        repliedTO: repliedTO!,
        repliedMessage: repliedMess!,
        repliedMessageID: repliedMessID!,
        lang: toLANG ?? 'en',
        type: toType!,
      );
    } else {
      uploadVoice(duration: recordDuration);
    }
  }

  playAudio({required String url}) async {
    await audioPlayer.setUrl(url);
    await audioPlayer.play();
    update();
  }

  stopAudio() async {
    await audioPlayer.stop();
    update();
  }

  deleteFile(String s) async {
    await FirebaseStorage.instance.ref(s).delete();
  }

  @override
  onClose() async {
    _appCon.friendToken = null;
    await audioPlayer.dispose();
    await audioRecorder.dispose();
    dispose();
    super.onClose();
  }
}
