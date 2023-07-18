import 'dart:io';
import 'dart:math';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/global/notify_con.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

AppCon _appCon = Get.put(AppCon());

class PrivateChatsCon extends GetxController {
  @override
  onInit() {
    super.onInit();
    initChat();
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

  GlobalKey<FormState> fst = GlobalKey<FormState>();
  FocusNode iconF = FocusNode();
  CollectionReference<Map<String, dynamic>>? privatemessagesME;
  CollectionReference<Map<String, dynamic>>? privatemessagesFriend;
  DocumentReference<Map<String, dynamic>>? friendStatusInMY;
  DocumentReference<Map<String, dynamic>>? myStatusInFriend;

  initChat() async {
    friendUid = Get.arguments['friendUid'];
    friendName = Get.arguments['friendName'];
    friendPFP = Get.arguments['friendPFP'];
    friendToken = Get.arguments['friendToken'];
    AppCon appCon = Get.find();
    appCon.friendToken = friendToken;
    MyServices myServices = Get.find();
    Get.put(LangCon());
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    privatemessagesME = FirebaseFirestore.instance
        .collection('message/privates/$myUid/$friendUid/messages');
    privatemessagesFriend = FirebaseFirestore.instance
        .collection('message/privates/$friendUid/$myUid/messages');

    myServices.oneStream = privatemessagesME!
        .orderBy(
          'date',
          descending: true,
        )
        .snapshots();
    Get.put(NotifyCon());
    friendUid = friendUid;
    myStatusInFriend = privatemessagesFriend!.doc('STATUS$myUid');
    friendStatusInMY = privatemessagesME!.doc('STATUS$friendUid');
    setInCHAT();
    await appCon.getInfo();
  }

  setOutOfChat() async {
    await myServices.mySharedPrefs.setString('CurrentChatToken', '');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(myStatusInFriend!, {'status': ''});
    await batch.commit();
  }

  setInCHAT() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(myStatusInFriend!, {'status': 'In Chat'});
    await batch.commit();
  }

  deleteLast() async {
    WriteBatch batch0 = FirebaseFirestore.instance.batch();
    WriteBatch batch1 = FirebaseFirestore.instance.batch();

    await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: myUid)
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          String myDocID = element.reference.id;
          batch0.update(
            FirebaseFirestore.instance.collection('users').doc(myDocID),
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
        await batch0.commit();
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
          batch1.update(
            FirebaseFirestore.instance.collection('users').doc(myDocID),
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
        await batch1.commit();
      },
    );
  }

  setMess(date, mess) async {
    WriteBatch batch0 = FirebaseFirestore.instance.batch();
    WriteBatch batch1 = FirebaseFirestore.instance.batch();

    await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: myUid)
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          String myDocID = element.reference.id;
          batch0.update(
            FirebaseFirestore.instance.collection('users').doc(myDocID),
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
          await batch0.commit();
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
          batch1.update(
            FirebaseFirestore.instance.collection('users').doc(myDocID),
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
        await batch1.commit();
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
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.set(
      privatemessagesME!.doc((rand0 + rand1 + rand2).toString()),
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

    batch.set(
      privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()),
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
    batch.commit();
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
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(
      privatemessagesME!.doc((rand0 + rand1 + rand2).toString()),
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

    batch.set(
      privatemessagesFriend!.doc((rand0 + rand1 + rand2).toString()),
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
    batch.commit();
  }

  editMess(String iD, String message, String messLang) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      privatemessagesME!.doc(iD),
      {
        'message': message,
        'messLANG': messLang,
      },
    );
    batch.update(
      privatemessagesFriend!.doc(iD),
      {
        'message': message,
        'messLANG': messLang,
      },
    );

    batch.commit();
  }

  Future insertGif(String username, BuildContext context) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    final gif = await GiphyPicker.pickGif(
      fullScreenDialog: true,
      context: context,
      apiKey: 'my_apikey',
      rating: GiphyRating.r,
      lang: GiphyLanguage.english,
    );
    if (gif != null) {
      batch.set(myStatusInFriend!, {'status': 'Sending Gif'});
      batch.commit();
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
    WriteBatch batch = FirebaseFirestore.instance.batch();

    final gif = await GiphyPicker.pickGif(
      fullScreenDialog: true,
      sticker: false,
      context: context,
      apiKey: 'my_apikey',
      rating: GiphyRating.r,
      lang: GiphyLanguage.english,
    );
    if (gif != null) {
      batch.set(myStatusInFriend!, {'status': 'Sending Gif'});
      batch.commit();
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
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.delete(privatemessagesME!.doc(messageID));
    batch.delete(privatemessagesFriend!.doc(messageID));
    batch.commit();
  }

  uploadVid() async {
    WriteBatch batch0 = FirebaseFirestore.instance.batch();
    WriteBatch batch1 = FirebaseFirestore.instance.batch();
    WriteBatch batch2 = FirebaseFirestore.instance.batch();

    Reference? storageref;
    XFile? pickedvid =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedvid != null) {
      batch0.set(myStatusInFriend!, {'status': 'Sending Video'});
      await batch0.commit();
      String vidName = basename(pickedvid.path);

      vid = File(pickedvid.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('videos/$rand$vidName');
      Reference refThumb = FirebaseStorage.instance.ref('thumbnails/$rand');
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);

      batch1.set(
        privatemessagesME!.doc('$rand0$rand1'),
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

      batch1.set(
        privatemessagesFriend!.doc('$rand0$rand1'),
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

      await batch1.commit();
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
      batch2.update(
        privatemessagesME!.doc('$rand0$rand1'),
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

      batch2.update(
        privatemessagesFriend!.doc('$rand0$rand1'),
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

      await batch2.commit();
    }
  }

  uploadImage() async {
    WriteBatch batch0 = FirebaseFirestore.instance.batch();
    WriteBatch batch1 = FirebaseFirestore.instance.batch();
    WriteBatch batch2 = FirebaseFirestore.instance.batch();

    Reference? storageref;

    XFile? pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      batch0.set(myStatusInFriend!, {'status': 'Sending Image'});
      await batch0.commit();
      String imageName = basename(pickedimage.path);

      image = File(pickedimage.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('images/$rand$imageName');
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);
      batch1.set(
        privatemessagesME!.doc('$rand0$rand1'),
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
      batch1.set(
        privatemessagesFriend!.doc('$rand0$rand1'),
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

      await batch1.commit();
      await storageref.putFile(image!);

      imageUrl = await storageref.getDownloadURL().then(
        (value) async {
          batch2.update(
            privatemessagesME!.doc('$rand0$rand1'),
            {
              'image': value,
              'imagepath': pickedimage.path,
              'storageref': storageref!.fullPath.toString(),
              'isImgUploaded': true,
            },
          );
          batch2.update(
            privatemessagesFriend!.doc('$rand0$rand1'),
            {
              'image': value,
              'imagepath': pickedimage.path,
              'storageref': storageref.fullPath.toString(),
              'isImgUploaded': true,
            },
          );
          await batch2.commit();
          return null;
        },
      );
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
    WriteBatch batch0 = FirebaseFirestore.instance.batch();
    WriteBatch batch1 = FirebaseFirestore.instance.batch();
    WriteBatch batch2 = FirebaseFirestore.instance.batch();

    XFile? pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      batch0.set(myStatusInFriend!, {'status': 'Sending Image'});
      await batch0.commit();
      String imageName = basename(pickedimage.path);

      image = File(pickedimage.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('images/$rand$imageName');
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);
      batch1.set(
        privatemessagesME!.doc('$rand0$rand1'),
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
      batch1.set(
        privatemessagesFriend!.doc('$rand0$rand1'),
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
      await batch1.commit();

      await storageref.putFile(image!);

      imageUrl = await storageref.getDownloadURL().then(
        (value) async {
          batch2.update(
            privatemessagesME!.doc('$rand0$rand1'),
            {
              'image': value,
              'imagepath': pickedimage.path,
              'storageref': storageref!.fullPath.toString(),
              'isImgUploaded': true,
            },
          );
          batch2.update(
            privatemessagesFriend!.doc('$rand0$rand1'),
            {
              'image': value,
              'imagepath': pickedimage.path,
              'storageref': storageref.fullPath.toString(),
              'isImgUploaded': true,
            },
          );
          await batch2.commit();
          return null;
        },
      );
    }
  }

  uploadReplyVid({
    required String repliedTO,
    required String repliedMessage,
    required int repliedMessageID,
    required String lang,
    required String type,
  }) async {
    WriteBatch batch0 = FirebaseFirestore.instance.batch();
    WriteBatch batch1 = FirebaseFirestore.instance.batch();
    WriteBatch batch2 = FirebaseFirestore.instance.batch();
    Reference? storageref;
    XFile? pickedvid =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedvid != null) {
      // batch0.set(MYstatus_inMY!, {'status': 'Sending Video'});
      batch0.set(myStatusInFriend!, {'status': 'Sending Video'});
      await batch0.commit();
      String vidName = basename(pickedvid.path);

      vid = File(pickedvid.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('videos/$rand$vidName');
      Reference refThumb = FirebaseStorage.instance.ref('thumbnails/$rand');
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);
      batch1.set(privatemessagesME!.doc('$rand0$rand1'), {
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
      });
      batch1.set(privatemessagesFriend!.doc('$rand0$rand1'), {
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
      });

      await batch1.commit();
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
      batch2.update(
        privatemessagesME!.doc('$rand0$rand1'),
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
      batch2.update(
        privatemessagesFriend!.doc('$rand0$rand1'),
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
      await batch2.commit();
    }
  }

  deleteFile(String s) async {
    await FirebaseStorage.instance.ref(s).delete();
  }

  logOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    myServices.mySharedPrefs.setBool('loged', false);
    Get.offAllNamed(AppRoutes.sign);
  }
}
