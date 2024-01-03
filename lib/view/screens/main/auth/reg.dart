import 'package:sm_project/controller/auth/reg_con.dart';
import 'package:sm_project/core/const/decoration.dart';
import 'package:sm_project/view/widgets/auth/global/app_logo.dart';
import 'package:sm_project/view/widgets/auth/global/custom_column.dart';
import 'package:sm_project/view/widgets/auth/reg/forms/email_form.dart';
import 'package:sm_project/view/widgets/auth/reg/forms/pass_form.dart';
import 'package:sm_project/view/widgets/auth/reg/buttons/signup_button.dart';
import 'package:sm_project/view/widgets/auth/global/text.dart';
import 'package:sm_project/view/widgets/auth/sign/buttons/google_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegScreen extends StatelessWidget {
  const RegScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RegCon regCon = Get.put(RegCon());
    return Scaffold(
      body: CustomColumn(
        fst: regCon.fst,
        children: [
          const AppLogo(),
          const CustomText(
            text: 'Hi,',
          ),
          const CustomText(
            text:
                'Register With Your Email And Password\n Or Continue With Google',
            size: 18,
          ),
          SizedBox(height: AppDecoration().screenHeight * 0.03),
          const RegEmailForm(),
          const RegPassForm(),
          const Expanded(child: SizedBox()),
          const GoogleSignButton(),
          const RegSignUpCusttomButton(),
          SizedBox(height: AppDecoration().screenHeight * 0.04),
        ],
      ),
    );
  }
}
