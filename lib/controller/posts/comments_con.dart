import 'dart:io';
import 'dart:math';
import 'package:social_media_demo/controller/global/app_con.dart';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/global/notify_con.dart';
import 'package:social_media_demo/controller/global/obx_con.dart';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/models/comments_model.dart';
import 'package:social_media_demo/view/screens/media/video/videoscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

AppCon _appCon = Get.put(AppCon());
LangCon _langCon = Get.put(LangCon());
NotifyCon _notifyCon = Get.put(NotifyCon());

class CommentsCon extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCommentScreen();
  }

  Widget bottomWid = const SizedBox();
  User currentuser = FirebaseAuth.instance.currentUser!;
  late CollectionReference<Map<String, dynamic>> commRef;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  String? imageUrl;
  String? thumbUrl;
  String? addImagePath;
  String? vidUrl;
  File? image;
  File? vid;
  ScrollController textFieldScrollController = ScrollController();
  TextEditingController editCon = TextEditingController();
  int? rand;
  XFile? pickedimageUpload;
  XFile? pickedvid;
  bool? uploadingCommentImage;
  bool? uploadingCommentVid;
  FocusNode focusNodeIcon = FocusNode();
  GlobalKey<FormState> fst = GlobalKey<FormState>();
  late String postID;
  late String posterNAME;
  late String posterTOKEN;
  late String posterUid;
  late Stream stream;

  initCommentScreen() {
    postID = Get.arguments['postID'];
    posterUid = Get.arguments['posterUid'];
    posterNAME = Get.arguments['posterNAME'];
    posterTOKEN = Get.arguments['posterTOKEN'];

    Get.put(LangCon());
    Get.put(ObxCon());
    MyServices myServices = Get.find();

    commRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('comments');
    myServices.oneStream =
        commRef.orderBy('date', descending: false).snapshots();
    stream = myServices.oneStream!;
  }

  formatDate({required CommentsModel commentsModel}) {
    return DateFormat('y-M-d h:mm a').format(
      DateTime.parse(commentsModel.dateString!),
    );
  }

  manageComment({required CommentsModel commentsModel}) {
    if (commentsModel.data!.containsKey('liked$myUid') == false) {
      commRef.doc(commentsModel.docID).update(
        {'liked$myUid': false},
      );
    }
    if (commentsModel.data!.containsKey('disliked$myUid') == false) {
      commRef.doc(commentsModel.docID).update(
        {'disliked$myUid': false},
      );
    }
  }

  likedHandling({required CommentsModel commentsModel}) {
    return commentsModel.data!.containsKey('liked$myUid')
        ? commentsModel.data!['liked$myUid']
        : false;
  }

  dislikedHandling({required CommentsModel commentsModel}) {
    return commentsModel.data!.containsKey('disliked$myUid')
        ? commentsModel.data!['disliked$myUid']
        : false;
  }

  textComment({
    required String docID,
    String? myText,
    String? myLang,
    required String posterNAME,
    required String posterUID,
    required String posterTOKEN,
  }) async {
    int rand0 = Random().nextInt(1000000000);
    int rand1 = Random().nextInt(1000000000);

    commRef.doc('$rand0$rand1').set(
      {
        'pfp': _appCon.pfp,
        'UserID': currentuser.uid,
        'username': _appCon.name,
        'commentID': '$rand0$rand1',
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'isImgUploaded': false,
        'text': myText,
        'textLANG': myLang,
        'textOnly': true,
        'likes': 0,
        'dislikes': 0,
        'reps': 0,
        'image': null,
        'imagepath': null,
        'vid': null,
        'vidpath': null,
        'storageref': null,
        'isVidUploaded': null,
        'token': _notifyCon.myToken,
      },
    );
    _notifyCon.sendCommentNotify(docID, currentuser.uid, posterNAME,
        _appCon.name!, posterUID, posterTOKEN);
  }

  uploadCommentVid({
    required String docID,
    String? myLang,
    String? myText,
    required String posterNAME,
    required String posterUID,
    required String posterTOKEN,
  }) async {
    Reference? storageref;
    if (pickedvid != null) {
      uploadingCommentImage = null;
      String vidName = basename(pickedvid!.path);
      vid = File(pickedvid!.path);
      rand = Random().nextInt(1000000000);
      storageref =
          FirebaseStorage.instance.ref('comments/videos/$rand$vidName');
      Reference refThumb =
          FirebaseStorage.instance.ref('comments/videos/thumbnails/$rand');
      User? currentuser = FirebaseAuth.instance.currentUser;
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);
      commRef.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': currentuser!.uid,
          'username': _appCon.name,
          'commentID': '$rand0$rand1',
          'isVidUploaded': false,
          'isImgUploaded': null,
          'textOnly': false,
          'text': myText,
          'textLANG': myLang,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'likes': 0,
          'dislikes': 0,
          'reps': 0,
          'image': null,
          'imagepath': null,
          'vid': null,
          'vidname': vidName,
          'vidthumb': null,
          'vidpath': null,
          'storageref': null,
          'token': _notifyCon.myToken,
        },
      );

      String? thumbnail = await VideoThumbnail.thumbnailFile(
        video: pickedvid!.path,
        thumbnailPath: (await getExternalStorageDirectory())?.path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );

      await storageref.putFile(vid!);
      await refThumb.putFile(File(thumbnail!));

      vidUrl = await storageref.getDownloadURL();
      String vidthumblink = await refThumb.getDownloadURL();

      commRef.doc('$rand0$rand1').update(
        {
          'pfp': _appCon.pfp,
          'UserID': currentuser.uid,
          'username': _appCon.name,
          'likes': 0,
          'dislikes': 0,
          'reps': 0,
          'vid': vidUrl,
          'vidpath': pickedvid!.path,
          'vidthumbpath': thumbnail,
          'vidthumb': vidthumblink,
          'storageref_vid': storageref.fullPath.toString(),
          'storageref_thumb': refThumb.fullPath.toString(),
          'isVidUploaded': true,
        },
      );
      pickedvid = null;
      thumbUrl = null;
      vidUrl = null;
    }
    _notifyCon.sendCommentNotify(docID, currentuser.uid, posterNAME,
        _appCon.name!, posterUID, posterTOKEN);
  }

  uploadCommentImage({
    required String docID,
    String? myLang,
    String? myText,
    required String posterNAME,
    required String posterUID,
    required String posterTOKEN,
  }) async {
    Reference? storageref;
    if (pickedimageUpload != null) {
      String imageName = basename(pickedimageUpload!.path);

      image = File(pickedimageUpload!.path);
      rand = Random().nextInt(1000000000);
      storageref =
          FirebaseStorage.instance.ref('comments/images/$rand$imageName');
      User? currentuser = FirebaseAuth.instance.currentUser;
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);

      commRef.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': currentuser!.uid,
          'username': _appCon.name,
          'commentID': '$rand0$rand1',
          'textOnly': false,
          'image': null,
          'text': myText,
          'textLANG': myLang,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'isImgUploaded': false,
          'likes': null,
          'dislikes': null,
          'reps': null,
          'imagepath': null,
          'vid': null,
          'vidpath': null,
          'storageref': null,
          'isVidUploaded': null,
          'token': _notifyCon.myToken,
        },
      );
      await storageref.putFile(image!);

      imageUrl = await storageref.getDownloadURL().then(
        (value) {
          commRef.doc('$rand0$rand1').update(
            {
              'likes': 0,
              'dislikes': 0,
              'reps': 0,
              'image': value,
              'imagepath': pickedimageUpload!.path,
              'storageref': storageref!.fullPath.toString(),
              'isImgUploaded': true,
            },
          );
          return null;
        },
      );
    }
    pickedimageUpload = null;
    addImagePath = null;
    _notifyCon.sendCommentNotify(docID, currentuser.uid, posterNAME,
        _appCon.name!, posterUID, posterTOKEN);
  }

  likes(String docID, int count) async {
    await commRef.doc(docID).update(
      {
        'likes': count + 1,
      },
    );
  }

  disLikes(String docID, int count) async {
    await commRef.doc(docID).update(
      {
        'dislikes': count + 1,
      },
    );
  }

  deleteFile(String s) async {
    await FirebaseStorage.instance.ref(s).delete();
  }

  deleteDoc(
    String docID,
  ) async {
    await commRef.doc(docID).delete();
  }

  editComment(String commentID, String newpost) async {
    _langCon.checkTextLang(newpost);
    await commRef.doc(commentID).update(
      {
        'text': newpost,
        'textLANG': _langCon.langTextField,
      },
    );
  }

  commentScreenVid(BuildContext context) async {
    XFile? addPickedvid =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (addPickedvid != null) {
      pickedimageUpload = null;
      imageUrl = null;
      uploadingCommentImage = false;
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: addPickedvid.path,
        thumbnailPath: (await getExternalStorageDirectory())?.path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );
      vid = File(addPickedvid.path);
      bottomWid = GestureDetector(
        onTap: () {
          Get.to(
            () => const VideoScreen(),
            transition: Transition.downToUp,
            arguments: {
              'vidlocal': vid,
            },
          );
        },
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        File(thumbnail!),
                        fit: BoxFit.contain,
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
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(
                  'Send Video',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
      update();
      pickedvid = addPickedvid;
      uploadingCommentVid = true;
    }
  }

  commentScreenImage() async {
    XFile? pickedimageAdd =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimageAdd != null) {
      uploadingCommentVid = null;

      pickedvid = null;
      vidUrl = null;
      vid = null;
      uploadingCommentImage = true;
      addImagePath = pickedimageAdd.path;
      pickedimageUpload = pickedimageAdd;
    }
  }

  editDia({
    required String oldPost,
    required dynamic postDIR,
    required String postID,
    required bool textOnly,
  }) {
    editCon.text = oldPost;
    Get.defaultDialog(
      title: 'Edit Post',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: SizedBox(
              height: 77,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 80, maxWidth: 80),
                child: TextFormField(
                  scrollController: textFieldScrollController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  textDirection: postDIR,
                  controller: editCon,
                  decoration: InputDecoration(
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
                    label: const Text(
                      'Comment',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    hintText: "....",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.black,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (textOnly) {
                    if (editCon.text.trim().isNotEmpty) {
                      Get.back();
                      editComment(postID, editCon.text.trim());
                    } else if (editCon.text.trim().isEmpty) {
                      Get.defaultDialog(
                        content: const Text('Comment Is Empty !!'),
                      );
                    }
                  } else {
                    Get.back();
                    editComment(postID, editCon.text.trim());
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
