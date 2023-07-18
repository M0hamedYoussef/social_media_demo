import 'package:social_media_demo/controller/auth/login_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignEmailForm extends GetView<LoginCon> {
  const SignEmailForm({super.key});

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = controller.fstEmailFocus;
    FocusNode nextFocusNode = controller.fstPassFocus;
    TextEditingController emailCon = controller.signEmailCon;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextFormField(
        focusNode: focusNode,
        validator: (value) {
          if (value!.isEmpty == true) {
            return "Please Type The Email";
          } else if (value.contains('.') == false ||
              value.contains('@') == false ||
              value.length < 4) {
            return "Please Type Valid Email";
          }
          return null;
        },
        controller: emailCon,
        onEditingComplete: () {
          nextFocusNode.requestFocus();
        },
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
            'Email',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          hintText: "Enter Your Email",
        ),
      ),
    );
  }
}
