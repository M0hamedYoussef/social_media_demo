import 'package:social_media_demo/controller/auth/login_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignButton extends GetView<LoginCon> {
  const SignButton({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> fst = controller.fst;
    FocusNode fstEmailFocus = controller.fstEmailFocus;
    FocusNode fstPassFocus = controller.fstPassFocus;
    TextEditingController emailCon = controller.signEmailCon;
    TextEditingController passCon = controller.signPassCon;
    return Padding(
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
          child: const Text(
            'Sign In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
