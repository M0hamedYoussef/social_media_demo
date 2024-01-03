import 'package:sm_project/controller/auth/login_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';

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
            borderSide: const BorderSide(color: AppColors.darkBlue1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.darkBlue1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.darkBlue1),
          ),
          label: const Text(
            'Email',
            style: TextStyle(fontSize: 15, color: AppColors.darkBlue1),
          ),
          hintText: "Enter Your Email",
          hintStyle: TextStyle(
            fontSize: 15,
            color: AppColors.darkBlue1.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
