import 'dart:io';
import 'package:social_media_demo/core/services/my_services.dart';
import 'package:social_media_demo/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class LoginCon extends GetxController {
  MyServices myServices = Get.find();
  //////////////////////////////////////////
  @override
  void onClose() {
    imageUrl = null;
    usernameCon.dispose();
    super.onClose();
  }

  bool passeye = true;

  final TextEditingController signEmailCon = TextEditingController();
  final TextEditingController signPassCon = TextEditingController();
  final GlobalKey<FormState> fst = GlobalKey<FormState>();
  final FocusNode fstPassFocus = FocusNode();
  final FocusNode fstEmailFocus = FocusNode();

  File? image;
  String? imageUrl;
  XFile? pickedimage;
  bool isUploading = false;
  String buttonText = 'Not Now';
  UserCredential? credential;
  TextEditingController usernameCon = TextEditingController();
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  Future<String?> token = FirebaseMessaging.instance.getToken();

  changeobsc() {
    passeye = !passeye;
    update();
  }

  uploadPFP() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    Reference? storageref;
    pickedimage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      isUploading = true;
      update();

      image = File(pickedimage!.path);
      storageref = FirebaseStorage.instance.ref('pfp/$userID');

      await storageref.putFile(image!);
      update();

      imageUrl = await storageref.getDownloadURL();
      isUploading = false;
      await users.where('UserID', isEqualTo: userID).get().then(
        (value) async {
          for (var element in value.docs) {
            String docid = element.reference.id;
            await users.doc(docid).update(
              {
                'pfp': imageUrl,
              },
            );
          }
        },
      );
      buttonText = 'Confirm';
      update();
    }
  }

  signInWithEmail({required String email, required String pass}) async {
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (credential!.user?.emailVerified == false) {
        Get.back();
        Get.snackbar(
          backgroundColor: Colors.transparent,
          'Verification Sent',
          'Check Your Email !',
        );
        await user!.sendEmailVerification();
      } else if (credential!.user?.emailVerified == true) {
        await users.where('UserID', isEqualTo: user!.uid).get().then(
          (value) async {
            for (var element in value.docs) {
              String docid = element.reference.id;
              if (await element.data()['UserName'] == null &&
                  await element.data()['pfp'] == null) {
                Get.defaultDialog(
                  title: "Enter Your Username",
                  content: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: usernameCon,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              label: const Text(
                                'username',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              hintText: "Enter Your Username",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
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
                                onPressed: () async {
                                  if (usernameCon.text.trim().isEmpty) {
                                    Get.defaultDialog(
                                      title: 'Alert',
                                      middleText: 'Username Must Be Not Empty',
                                    );
                                    usernameCon.clear();
                                  }
                                  if (usernameCon.text.isNotEmpty) {
                                    if (usernameCon.text.trim().length >= 4 &&
                                        usernameCon.text.trim().length < 15) {
                                      Get.back();
                                      Get.defaultDialog(
                                        title: 'Choose Profile Picture',
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            GetBuilder<LoginCon>(
                                              builder: (controller) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: isUploading
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundImage:
                                                            imageUrl != null
                                                                ? NetworkImage(
                                                                    imageUrl!)
                                                                : const NetworkImage(
                                                                    'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
                                                                  ),
                                                        radius: 100,
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                MaterialButton(
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    uploadPFP();
                                                  },
                                                  child: const Text(
                                                    'Upload Image',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                GetBuilder<LoginCon>(
                                                  builder: (con) =>
                                                      MaterialButton(
                                                    color: Colors.black,
                                                    onPressed: () async {
                                                      if (buttonText ==
                                                          'Not Now') {
                                                        await users
                                                            .doc(docid)
                                                            .update(
                                                          {
                                                            'pfp':
                                                                'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'
                                                          },
                                                        );
                                                        Get.offAllNamed(
                                                            AppRoutes.main);
                                                        await myServices
                                                            .mySharedPrefs
                                                            .setString('pfp',
                                                                'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg');
                                                        await myServices
                                                            .mySharedPrefs
                                                            .setString(
                                                                'username',
                                                                usernameCon
                                                                    .text);
                                                        await myServices
                                                            .mySharedPrefs
                                                            .setBool(
                                                                'loged', true);
                                                        imageUrl = null;
                                                      } else if (buttonText ==
                                                          'Confirm') {
                                                        Get.offAllNamed(
                                                            AppRoutes.main);
                                                        await myServices
                                                            .mySharedPrefs
                                                            .setBool(
                                                                'loged', true);
                                                        await myServices
                                                            .mySharedPrefs
                                                            .setString('pfp',
                                                                imageUrl!);
                                                        await myServices
                                                            .mySharedPrefs
                                                            .setString(
                                                                'username',
                                                                usernameCon
                                                                    .text);
                                                        imageUrl = null;
                                                        buttonText = 'Not Now';
                                                      }
                                                    },
                                                    child: Text(
                                                      buttonText,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                      await users.doc(docid).update(
                                        {
                                          'Email': email,
                                          'Password': pass,
                                          'UserID': user.uid,
                                          'UserName': usernameCon.text,
                                          'lastmess': null,
                                          'lastdate': null,
                                          'token': await token,
                                        },
                                      );
                                    } else if (usernameCon.text.trim().length <
                                            4 &&
                                        usernameCon.text.trim().isNotEmpty) {
                                      Get.defaultDialog(
                                        title: 'Alert',
                                        middleText:
                                            'Username Must Be Longer Than 4',
                                      );
                                    } else if (usernameCon.text.trim().length >
                                            15 &&
                                        usernameCon.text.trim().isNotEmpty) {
                                      Get.defaultDialog(
                                        title: 'Alert',
                                        middleText:
                                            'Username Must Be Smaller Than 15',
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                imageUrl = null;
              } else if (element.data()['UserName'] == null) {
                Get.defaultDialog(
                  title: "Enter Your Username",
                  content: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: usernameCon,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              label: const Text(
                                'username',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              hintText: "Enter Your Username",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
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
                                onPressed: () async {
                                  if (usernameCon.text.trim().isEmpty) {
                                    Get.defaultDialog(
                                      title: 'Alert',
                                      middleText: 'Username Must Be Not Empty',
                                    );
                                    usernameCon.clear();
                                  }
                                  if (usernameCon.text.isNotEmpty) {
                                    if (usernameCon.text.trim().length >= 4 &&
                                        usernameCon.text.trim().length < 15) {
                                      Get.offAllNamed(AppRoutes.main);
                                      await myServices.mySharedPrefs.setString(
                                          'username', usernameCon.text);
                                      await myServices.mySharedPrefs
                                          .setBool('loged', true);
                                      await users.doc(docid).update(
                                        {
                                          'Email': email,
                                          'Password': pass,
                                          'UserID': user.uid,
                                          'UserName': usernameCon.text,
                                          'lastmess': null,
                                          'lastdate': null,
                                          'token': await token,
                                        },
                                      );
                                    } else if (usernameCon.text.trim().length <
                                            4 &&
                                        usernameCon.text.trim().isNotEmpty) {
                                      Get.defaultDialog(
                                        title: 'Alert',
                                        middleText:
                                            'Username Must Be Longer Than 4',
                                      );
                                    } else if (usernameCon.text.trim().length >
                                            15 &&
                                        usernameCon.text.trim().isNotEmpty) {
                                      Get.defaultDialog(
                                        title: 'Alert',
                                        middleText:
                                            'Username Must Be Smaller Than 15',
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                imageUrl = null;
              } else if (element.data()['pfp'] == null) {
                Get.defaultDialog(
                  title: 'Choose Profile Picture',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GetBuilder<LoginCon>(
                        builder: (controller) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isUploading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl!)
                                      : const NetworkImage(
                                          'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
                                        ),
                                  radius: 100,
                                  backgroundColor: Colors.black,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            color: Colors.black,
                            onPressed: () {
                              uploadPFP();
                            },
                            child: const Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GetBuilder<LoginCon>(
                            builder: (con) => MaterialButton(
                              color: Colors.black,
                              onPressed: () async {
                                if (buttonText == 'Not Now') {
                                  await users.doc(docid).update(
                                    {
                                      'pfp':
                                          'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'
                                    },
                                  );
                                  Get.offAllNamed(AppRoutes.main);
                                  await myServices.mySharedPrefs.setString(
                                      'pfp',
                                      'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg');
                                  await myServices.mySharedPrefs
                                      .setBool('loged', true);
                                  imageUrl = null;
                                } else if (buttonText == 'Confirm') {
                                  Get.offAllNamed(AppRoutes.main);
                                  await myServices.mySharedPrefs
                                      .setBool('loged', true);
                                  imageUrl = null;
                                  buttonText = 'Not Now';
                                }
                              },
                              child: Text(
                                buttonText,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                imageUrl = null;
                buttonText = 'Not Now';
              } else {
                await users.doc(docid).update(
                  {
                    'token': await token,
                  },
                );
                Get.offAllNamed(AppRoutes.main);
                imageUrl = null;
                buttonText = 'Not Now';
                await myServices.mySharedPrefs.setBool('loged', true);
              }

              imageUrl = null;
            }
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.back();
        Get.defaultDialog(
          title: 'Error',
          middleText: 'User Not found',
        );
      } else if (e.code == 'wrong-password') {
        Get.back();
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Wrong Password',
        );
      }
    }
  }

  googleSign() async {
    Get.defaultDialog(
      title: '',
      content: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
    );
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) {
          users.doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (value) async {
              if (value.data() == null) {
                myServices.mySharedPrefs.setBool('loged', true);
                await users.doc(FirebaseAuth.instance.currentUser?.uid).set(
                  {
                    'UserID': FirebaseAuth.instance.currentUser?.uid,
                    'UserName': null,
                    'pfp': null,
                    'lastmess': null,
                    'lastdate': null,
                    'token': await token,
                  },
                  SetOptions(merge: true),
                );
                User? user = FirebaseAuth.instance.currentUser;
                await users.where('UserID', isEqualTo: user!.uid).get().then(
                  (value) async {
                    for (var element in value.docs) {
                      String docid = element.reference.id;
                      Get.back();
                      Get.defaultDialog(
                        title: "Enter Your Username",
                        content: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: usernameCon,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    label: const Text(
                                      'username',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    hintText: "Enter Your Username",
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 5),
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
                                      onPressed: () async {
                                        if (usernameCon.text.trim().isEmpty) {
                                          Get.defaultDialog(
                                            title: 'Alert',
                                            middleText:
                                                'Username Must Be Not Empty',
                                          );
                                          usernameCon.clear();
                                        }
                                        if (usernameCon.text.isNotEmpty) {
                                          if (usernameCon.text.trim().length >=
                                                  4 &&
                                              usernameCon.text.trim().length <
                                                  15) {
                                            Get.back();
                                            Get.defaultDialog(
                                              title: 'Choose Profile Picture',
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  GetBuilder<LoginCon>(
                                                    builder: (controller) =>
                                                        Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: isUploading
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              backgroundImage: imageUrl !=
                                                                      null
                                                                  ? NetworkImage(
                                                                      imageUrl!)
                                                                  : const NetworkImage(
                                                                      'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
                                                                    ),
                                                              radius: 100,
                                                              backgroundColor:
                                                                  Colors.black,
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      MaterialButton(
                                                        color: Colors.black,
                                                        onPressed: () {
                                                          uploadPFP();
                                                        },
                                                        child: const Text(
                                                          'Upload Image',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      GetBuilder<LoginCon>(
                                                        builder: (con) =>
                                                            MaterialButton(
                                                          color: Colors.black,
                                                          onPressed: () async {
                                                            if (buttonText ==
                                                                'Not Now') {
                                                              await users
                                                                  .doc(docid)
                                                                  .update(
                                                                {
                                                                  'pfp':
                                                                      'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'
                                                                },
                                                              );
                                                              Get.offAllNamed(
                                                                  AppRoutes
                                                                      .main);
                                                              await myServices
                                                                  .mySharedPrefs
                                                                  .setString(
                                                                      'username',
                                                                      usernameCon
                                                                          .text);
                                                              await myServices
                                                                  .mySharedPrefs
                                                                  .setString(
                                                                      'pfp',
                                                                      'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg');
                                                              imageUrl = null;
                                                            } else if (buttonText ==
                                                                'Confirm') {
                                                              Get.offAllNamed(
                                                                  AppRoutes
                                                                      .main);
                                                              await myServices
                                                                  .mySharedPrefs
                                                                  .setString(
                                                                      'username',
                                                                      usernameCon
                                                                          .text);
                                                              await myServices
                                                                  .mySharedPrefs
                                                                  .setString(
                                                                      'pfp',
                                                                      imageUrl!);
                                                              imageUrl = null;
                                                              buttonText =
                                                                  'Not Now';
                                                            }
                                                          },
                                                          child: Text(
                                                            buttonText,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                            await users.doc(docid).update(
                                              {
                                                'UserID': user.uid,
                                                'UserName': usernameCon.text,
                                                'lastmess': null,
                                                'lastdate': null,
                                              },
                                            );
                                          } else if (usernameCon.text
                                                      .trim()
                                                      .length <
                                                  4 &&
                                              usernameCon.text
                                                  .trim()
                                                  .isNotEmpty) {
                                            Get.defaultDialog(
                                              title: 'Alert',
                                              middleText:
                                                  'Username Must Be Longer Than 4',
                                            );
                                          } else if (usernameCon.text
                                                      .trim()
                                                      .length >
                                                  15 &&
                                              usernameCon.text
                                                  .trim()
                                                  .isNotEmpty) {
                                            Get.defaultDialog(
                                              title: 'Alert',
                                              middleText:
                                                  'Username Must Be Smaller Than 15',
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      await myServices.mySharedPrefs.setBool('loged', true);
                      buttonText = 'Not Now';
                      imageUrl = null;
                    }
                  },
                );
              } else {
                User? user = FirebaseAuth.instance.currentUser;
                await users.where('UserID', isEqualTo: user!.uid).get().then(
                  (value) async {
                    for (var element in value.docs) {
                      String docid = element.reference.id;
                      if (element.data()['UserName'] == null &&
                          element.data()['pfp'] == null) {
                        users
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then(
                          (value) async {
                            users
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update(
                              {
                                'UserID':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'token': await token,
                              },
                            );
                          },
                        );
                        Get.back();
                        Get.defaultDialog(
                          title: "Enter Your Username",
                          content: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: usernameCon,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      label: const Text(
                                        'username',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      hintText: "Enter Your Username",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 5),
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
                                        onPressed: () async {
                                          if (usernameCon.text.trim().isEmpty) {
                                            Get.defaultDialog(
                                              title: 'Alert',
                                              middleText:
                                                  'Username Must Be Not Empty',
                                            );
                                            usernameCon.clear();
                                          }
                                          if (usernameCon.text.isNotEmpty) {
                                            if (usernameCon.text
                                                        .trim()
                                                        .length >=
                                                    4 &&
                                                usernameCon.text.trim().length <
                                                    15) {
                                              Get.back();
                                              Get.defaultDialog(
                                                title: 'Choose Profile Picture',
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    GetBuilder<LoginCon>(
                                                      builder: (controller) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: isUploading
                                                            ? const Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            : CircleAvatar(
                                                                backgroundImage: imageUrl !=
                                                                        null
                                                                    ? NetworkImage(
                                                                        imageUrl!)
                                                                    : const NetworkImage(
                                                                        'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
                                                                      ),
                                                                radius: 100,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        MaterialButton(
                                                          color: Colors.black,
                                                          onPressed: () {
                                                            uploadPFP();
                                                          },
                                                          child: const Text(
                                                            'Upload Image',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        GetBuilder<LoginCon>(
                                                          builder: (con) =>
                                                              MaterialButton(
                                                            color: Colors.black,
                                                            onPressed:
                                                                () async {
                                                              if (buttonText ==
                                                                  'Not Now') {
                                                                await users
                                                                    .doc(docid)
                                                                    .update(
                                                                  {
                                                                    'pfp':
                                                                        'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'
                                                                  },
                                                                );
                                                                Get.offAllNamed(
                                                                    AppRoutes
                                                                        .main);
                                                                await myServices
                                                                    .mySharedPrefs
                                                                    .setString(
                                                                        'username',
                                                                        usernameCon
                                                                            .text);
                                                                await myServices
                                                                    .mySharedPrefs
                                                                    .setString(
                                                                        'pfp',
                                                                        'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg');
                                                                imageUrl = null;
                                                              } else if (buttonText ==
                                                                  'Confirm') {
                                                                Get.offAllNamed(
                                                                    AppRoutes
                                                                        .main);
                                                                await myServices
                                                                    .mySharedPrefs
                                                                    .setString(
                                                                        'username',
                                                                        usernameCon
                                                                            .text);
                                                                await myServices
                                                                    .mySharedPrefs
                                                                    .setString(
                                                                        'pfp',
                                                                        imageUrl!);
                                                                buttonText =
                                                                    'Not Now';

                                                                imageUrl = null;
                                                              }
                                                            },
                                                            child: Text(
                                                              buttonText,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                              await users.doc(docid).update(
                                                {
                                                  'UserID': user.uid,
                                                  'UserName': usernameCon.text,
                                                  'lastmess': null,
                                                  'lastdate': null,
                                                  'token': await token,
                                                },
                                              );
                                            } else if (usernameCon.text
                                                        .trim()
                                                        .length <
                                                    4 &&
                                                usernameCon.text
                                                    .trim()
                                                    .isNotEmpty) {
                                              Get.defaultDialog(
                                                title: 'Alert',
                                                middleText:
                                                    'Username Must Be Longer Than 4',
                                              );
                                            } else if (usernameCon.text
                                                        .trim()
                                                        .length >
                                                    15 &&
                                                usernameCon.text
                                                    .trim()
                                                    .isNotEmpty) {
                                              Get.defaultDialog(
                                                title: 'Alert',
                                                middleText:
                                                    'Username Must Be Smaller Than 15',
                                              );
                                            }
                                          }
                                        },
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        await myServices.mySharedPrefs.setBool('loged', true);
                        buttonText = 'Not Now';
                        imageUrl = null;
                      } else if (element.data()['UserName'] == null) {
                        Get.defaultDialog(
                          title: "Enter Your Username",
                          content: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: usernameCon,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      label: const Text(
                                        'username',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      hintText: "Enter Your Username",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 5),
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
                                        onPressed: () async {
                                          if (usernameCon.text.trim().isEmpty) {
                                            Get.defaultDialog(
                                              title: 'Alert',
                                              middleText:
                                                  'Username Must Be Not Empty',
                                            );
                                            usernameCon.clear();
                                          }
                                          if (usernameCon.text.isNotEmpty) {
                                            if (usernameCon.text
                                                        .trim()
                                                        .length >=
                                                    4 &&
                                                usernameCon.text.trim().length <
                                                    15) {
                                              Get.offAllNamed(AppRoutes.main);
                                              await myServices.mySharedPrefs
                                                  .setString('username',
                                                      usernameCon.text);
                                              await users.doc(docid).update(
                                                {
                                                  'UserID': user.uid,
                                                  'UserName': usernameCon.text,
                                                  'lastmess': null,
                                                  'lastdate': null,
                                                  'token': await token,
                                                },
                                              );
                                            } else if (usernameCon.text
                                                        .trim()
                                                        .length <
                                                    4 &&
                                                usernameCon.text
                                                    .trim()
                                                    .isNotEmpty) {
                                              Get.defaultDialog(
                                                title: 'Alert',
                                                middleText:
                                                    'Username Must Be Longer Than 4',
                                              );
                                            } else if (usernameCon.text
                                                        .trim()
                                                        .length >
                                                    15 &&
                                                usernameCon.text
                                                    .trim()
                                                    .isNotEmpty) {
                                              Get.defaultDialog(
                                                title: 'Alert',
                                                middleText:
                                                    'Username Must Be Smaller Than 15',
                                              );
                                            }
                                          }
                                        },
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        await myServices.mySharedPrefs.setBool('loged', true);
                        buttonText = 'Not Now';
                        imageUrl = null;
                      } else if (element.data()['pfp'] == null) {
                        Get.defaultDialog(
                          title: 'Choose Profile Picture',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GetBuilder<LoginCon>(
                                builder: (controller) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: isUploading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: imageUrl != null
                                              ? NetworkImage(imageUrl!)
                                              : const NetworkImage(
                                                  'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
                                                ),
                                          radius: 100,
                                          backgroundColor: Colors.black,
                                        ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      uploadPFP();
                                    },
                                    child: const Text(
                                      'Upload Image',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GetBuilder<LoginCon>(
                                    builder: (con) => MaterialButton(
                                      color: Colors.black,
                                      onPressed: () async {
                                        if (buttonText == 'Not Now') {
                                          await users.doc(docid).update(
                                            {
                                              'pfp':
                                                  'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'
                                            },
                                          );
                                          Get.offAllNamed(AppRoutes.main);
                                          await myServices.mySharedPrefs.setString(
                                              'pfp',
                                              'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg');
                                          imageUrl = null;
                                        } else if (buttonText == 'Confirm') {
                                          Get.offAllNamed(AppRoutes.main);
                                          buttonText = 'Not Now';

                                          await myServices.mySharedPrefs
                                              .setString('pfp', imageUrl!);
                                          imageUrl = null;
                                        }
                                      },
                                      child: Text(
                                        buttonText,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                        await myServices.mySharedPrefs.setBool('loged', true);
                        buttonText = 'Not Now';
                        imageUrl = null;
                      } else {
                        users
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then(
                          (value) async {
                            users
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update(
                              {
                                'UserID':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'token': await token,
                              },
                            );
                          },
                        );
                        Get.offAllNamed(AppRoutes.main);
                        await myServices.mySharedPrefs.setBool('loged', true);
                        buttonText = 'Not Now';
                        imageUrl = null;
                      }
                    }
                  },
                );
              }
              buttonText = 'Not Now';
              imageUrl = null;
            },
          );
        },
      );
    } on Exception catch (_) {}
  }
}
