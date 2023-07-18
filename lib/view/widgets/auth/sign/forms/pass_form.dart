import 'package:social_media_demo/controller/auth/login_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignPassForm extends GetView<LoginCon> {
  const SignPassForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginCon loginCon = Get.find();
    GlobalKey<FormState> fst = controller.fst;
    FocusNode fstEmailFocus = controller.fstEmailFocus;
    FocusNode fstPassFocus = controller.fstPassFocus;
    TextEditingController emailCon = controller.signEmailCon;
    TextEditingController passCon = controller.signPassCon;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GetBuilder<LoginCon>(
        builder: (con) => TextFormField(
          focusNode: fstPassFocus,
          obscureText: con.passeye,
          validator: (value) {
            if (value!.isEmpty == true) {
              return "Please Type The Password";
            } else if (value.length < 10) {
              return "Please Type Valid Password";
            }
            return null;
          },
          controller: passCon,
          onEditingComplete: () {
            if (fst.currentState!.validate()) {
              fstPassFocus.unfocus();
              fstEmailFocus.unfocus();

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

              controller.signInWithEmail(
                email: emailCon.text.trim(),
                pass: passCon.text.trim(),
              );
            }
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
              'Password',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            hintText: "Enter Your Password",
            suffixIcon: IconButton(
              icon: Icon(
                con.passeye ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                loginCon.changeobsc();
              },
            ),
          ),
        ),
      ),
    );
  }
}
