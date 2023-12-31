import 'package:sm_project/controller/auth/reg_con.dart';
import 'package:flutter/material.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:get/get.dart';

class RegSignUpCusttomButton extends GetView<RegCon> {
  const RegSignUpCusttomButton({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> fst = controller.fst;
    FocusNode fstEmailFocus = controller.fstEmailFocus;
    FocusNode fstPassFocus = controller.fstPassFocus;
    TextEditingController emailCon = controller.regEmailCon;
    TextEditingController passCon = controller.regPassCon;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkBlue,
            foregroundColor: AppColors.darkBlue1,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            if (fst.currentState!.validate()) {
              fstEmailFocus.unfocus();
              fstPassFocus.unfocus();
              Get.defaultDialog(
                title: '',
                content: Container(
                  color: AppColors.white,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.black,
                    ),
                  ),
                ),
              );
              controller.regWithEmail(
                regEmailCon: emailCon.text.trim(),
                regPassCon: passCon.text.trim(),
              );
            }
          },
          child: const Text(
            'Sing Up',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
