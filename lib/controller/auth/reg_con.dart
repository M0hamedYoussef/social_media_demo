import 'package:sm_project/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegCon extends GetxController {
  final TextEditingController regEmailCon = TextEditingController();
  final TextEditingController regPassCon = TextEditingController();
  final GlobalKey<FormState> fst = GlobalKey<FormState>();
  final FocusNode fstPassFocus = FocusNode();
  final FocusNode fstEmailFocus = FocusNode();

  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  UserCredential? credential;
  Future<String?> token = FirebaseMessaging.instance.getToken();

  regWithEmail({
    required String regEmailCon,
    required String regPassCon,
  }) async {
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: regEmailCon,
        password: regPassCon,
      );
      users.doc(FirebaseAuth.instance.currentUser!.uid).set(
        {
          'Email': regEmailCon,
          'Password': regPassCon,
          'UserID': FirebaseAuth.instance.currentUser!.uid,
          'token': await token,
          'UserName': null,
          'pfp': null,
          'friends': [],
          'lastmess': null,
          'lastdate': null,
        },
      );
      User? user = FirebaseAuth.instance.currentUser;
      Get.snackbar(
        'Verification Sent',
        'Check Your Email !',
      );
      await user?.sendEmailVerification();
      Get.offAllNamed(AppRoutes.sign);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.back();
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Too Weak Password',
        );
      } else if (e.code == 'email-already-in-use') {
        Get.back();
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Email Already In Use',
        );
      }
    } catch (e) {
      null;
    }
  }
}
