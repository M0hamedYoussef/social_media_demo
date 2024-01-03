import 'dart:io';
import 'dart:math';
import 'package:sm_project/controller/global/app_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/controller/global/notify_con.dart';
import 'package:sm_project/core/services/my_services.dart';
import 'package:sm_project/models/post_model.dart';
import 'package:sm_project/view/screens/main/media/video/videoscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

AppCon _appCon = Get.put(AppCon());
LangCon _langCon = Get.put(LangCon());
NotifyCon _notifyCon = Get.put(NotifyCon());
MyServices _myServices = Get.find();

class PostsCon extends GetxController {
  @override
  onInit() async {
    if (_myServices.mySharedPrefs.getString('username') != null &&
        _myServices.mySharedPrefs.getString('pfp') != null) {
      _appCon.name = _myServices.mySharedPrefs.getString('username');
      _appCon.pfp = _myServices.mySharedPrefs.getString('pfp');
    } else {
      await _appCon.getInfo();
    }
    _notifyCon.initMess();
    super.onInit();
  }

  Widget vidImg = const SizedBox();
  String initVAL = '';
  CollectionReference<Map<String, dynamic>> addPosts =
      FirebaseFirestore.instance.collection('addposts');
  CollectionReference<Map<String, dynamic>> posts =
      FirebaseFirestore.instance.collection('posts');

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
  User currentuser = FirebaseAuth.instance.currentUser!;

  getCommentCount({required PostModel postModel}) {
    var snaps = FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.docID)
        .collection('comments')
        .snapshots();
    snaps.listen(
      (event) {
        posts.doc(postModel.docID).update(
          {
            'comments': event.docs.length,
          },
        );
      },
    );
  }

  formatDate({required PostModel postModel}) {
    String formated = DateTime.parse(
      postModel.dateString!,
    ).toString();
    return formated;
  }

  postManage({required PostModel postModel}) {
    if (postModel.data!.containsKey('liked$myUid') == false) {
      posts.doc(postModel.docID).update(
        {'liked$myUid': false},
      );
    }

    if (postModel.data!.containsKey('disliked$myUid') == false) {
      posts.doc(postModel.docID).update(
        {'disliked$myUid': false},
      );
    }
  }

  likedHandling({required PostModel postModel}) {
    return postModel.data!.containsKey('liked$myUid')
        ? postModel.data!['liked$myUid']
        : false;
  }

  dislikedHandling({required PostModel postModel}) {
    return postModel.data!.containsKey('disliked$myUid')
        ? postModel.data!['disliked$myUid']
        : false;
  }

  textPost({String? myText, String? myLang}) async {
    User? currentuser = FirebaseAuth.instance.currentUser;
    int rand0 = Random().nextInt(1000000000);
    int rand1 = Random().nextInt(1000000000);
    posts.doc('$rand0$rand1').set(
      {
        'pfp': _appCon.pfp,
        'UserID': currentuser!.uid,
        'username': _appCon.name,
        'docID': '$rand0$rand1',
        'date': DateTime.now(),
        'dateSTRING': DateTime.now().toString(),
        'isImgUploaded': false,
        'text': myText,
        'textOnly': true,
        'textLANG': myLang,
        'likes': 0,
        'dislikes': 0,
        'comments': 0,
        'image': null,
        'imagepath': null,
        'vid': null,
        'vidpath': null,
        'storageref': null,
        'storageref_vid': null,
        'storageref_thumb': null,
        'isVidUploaded': null,
        'token': _notifyCon.myToken,
      },
    );
  }

  uploadVid({required String myLang, String? myText}) async {
    Reference? storageref;
    if (pickedvid != null) {
      String vidName = basename(pickedvid!.path);
      vid = File(pickedvid!.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('posts/videos/$rand$vidName');
      Reference refThumb =
          FirebaseStorage.instance.ref('posts/thumbnails/$rand');
      User? currentuser = FirebaseAuth.instance.currentUser;
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);
      posts.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': currentuser!.uid,
          'username': _appCon.name,
          'docID': '$rand0$rand1',
          'isVidUploaded': false,
          'textOnly': false,
          'text': myText,
          'textLANG': myLang,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'likes': 0,
          'dislikes': 0,
          'comments': 0,
          'image': null,
          'imagepath': null,
          'vid': null,
          'vidname': vidName,
          'vidthumb': null,
          'vidpath': pickedvid!.path,
          'storageref': null,
          'storageref_vid': null.toString(),
          'storageref_thumb': null.toString(),
          'isImgUploaded': null,
          'token': _notifyCon.myToken,
        },
      );
//
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: pickedvid!.path,
        thumbnailPath: (await getExternalStorageDirectory())?.path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );

      await storageref.putFile(vid!);
      await refThumb.putFile(File(thumbnail!));

      vidUrl = await storageref.getDownloadURL();
      String vidthumblink = await refThumb.getDownloadURL();

      posts.doc('$rand0$rand1').update(
        {
          'pfp': _appCon.pfp,
          'UserID': currentuser.uid,
          'username': _appCon.name,
          'likes': 0,
          'dislikes': 0,
          'comments': 0,
          'vid': vidUrl,
          'vidpath': pickedvid!.path,
          'vidthumbpaht': thumbnail,
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
  }

  uploadImage({required String myLang, String? myText}) async {
    Reference? storageref;

    if (pickedimageUpload != null) {
      String imageName = basename(pickedimageUpload!.path);

      image = File(pickedimageUpload!.path);
      rand = Random().nextInt(1000000000);
      storageref = FirebaseStorage.instance.ref('posts/images/$rand$imageName');
      User? currentuser = FirebaseAuth.instance.currentUser;
      int rand0 = Random().nextInt(1000000000);
      int rand1 = Random().nextInt(1000000000);

      posts.doc('$rand0$rand1').set(
        {
          'pfp': _appCon.pfp,
          'UserID': currentuser!.uid,
          'username': _appCon.name,
          'docID': '$rand0$rand1',
          'textOnly': false,
          'image': null,
          'text': myText,
          'textLANG': myLang,
          'date': DateTime.now(),
          'dateSTRING': DateTime.now().toString(),
          'isImgUploaded': false,
          'likes': null,
          'dislikes': null,
          'comments': null,
          'imagepath': null,
          'vid': null,
          'vidpath': null,
          'storageref': null,
          'storageref_vid': null,
          'storageref_thumb': null,
          'isVidUploaded': null,
          'token': _notifyCon.myToken,
        },
      );
      await storageref.putFile(image!);

      imageUrl = await storageref.getDownloadURL().then(
        (value) {
          posts.doc('$rand0$rand1').update(
            {
              'likes': 0,
              'dislikes': 0,
              'comments': 0,
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
  }

  addScreenImage() async {
    XFile? pickedimageAdd =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimageAdd != null) {
      pickedvid = null;
      vidUrl = null;
      vid = null;
    }
    addImagePath = pickedimageAdd!.path;
    pickedimageUpload = pickedimageAdd;
  }

  addScreenVid(BuildContext context) async {
    double screenWidth = MediaQuery.of(context).size.width;
    XFile? addPickedvid =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (addPickedvid != null) {
      pickedimageUpload = null;
      addImagePath = null;
      imageUrl = null;
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: addPickedvid.path,
        thumbnailPath: (await getExternalStorageDirectory())?.path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );
      vid = File(addPickedvid.path);
      vidImg = GestureDetector(
        onTap: () {
          Get.to(
            () => const VideoScreen(),
            transition: Transition.downToUp,
            arguments: {
              'vidlocal': vid,
            },
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: screenWidth,
              child: Image.file(
                File(thumbnail!),
                fit: BoxFit.fill,
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
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      );
      update();

      pickedvid = addPickedvid;
    }
  }

  likes(
    String docID,
    int count,
  ) async {
    await posts.doc(docID).update(
      {
        'likes': count + 1,
      },
    );
  }

  disLikes(
    String docID,
    int count,
  ) async {
    await posts.doc(docID).update(
      {
        'dislikes': count + 1,
      },
    );
  }

  deleteFile(
    String s,
  ) async {
    await FirebaseStorage.instance.ref(s).delete();
  }

  deleteDoc(
    String docID,
  ) async {
    await posts.doc(docID).delete();
    await posts.doc(docID).collection('comments').snapshots().forEach(
      (element) async {
        for (var ele in element.docs) {
          await posts.doc(docID).set({'I Wonder If I Can': '1%'});
          await ele.reference.delete();
          await posts.doc(docID).delete();
        }
      },
    );
  }

  editPost(String postID, String newpost) async {
    _langCon.checkTextLang(newpost);
    await posts.doc(postID).update(
      {
        'text': newpost,
        'textLANG': _langCon.langTextField,
      },
    );
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
                      'Post',
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
                      editPost(postID, editCon.text.trim());
                    } else if (editCon.text.trim().isEmpty) {
                      Get.defaultDialog(
                        content: const Text('Post Is Empty !!'),
                      );
                    }
                  } else {
                    Get.back();
                    editPost(postID, editCon.text.trim());
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











                         // postsCon.posts
                                        //     .doc(snapshot.data!.docs[index]
                                        //         ['docID'])
                                        //     .get()
                                        //     .then(
                                        //   (value) {
                                        //     if (value.data()!.containsKey(
                                        //             'liked$myUid') ==
                                        //         false) {
                                        //       postsCon.posts
                                        //           .doc(snapshot.data!
                                        //               .docs[index]['docID'])
                                        //           .set(
                                        //         {'liked$myUid': true},
                                        //         SetOptions(merge: true),
                                        //       );
                                        //     }else{
                                              
                                        //     }
                                        //   },
                                        // );
                                        // postsCon.Likes(
                                        //   snapshot.data!.docs[index]['docID'],
                                        //   snapshot.data!.docs[index]['likes'],
                                        // );