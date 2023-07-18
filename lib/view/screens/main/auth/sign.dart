import 'package:social_media_demo/controller/auth/login_con.dart';
import 'package:social_media_demo/core/const/decoration.dart';
import 'package:social_media_demo/view/widgets/auth/global/app_logo.dart';
import 'package:social_media_demo/view/widgets/auth/global/custom_column.dart';
import 'package:social_media_demo/view/widgets/auth/global/text.dart';
import 'package:social_media_demo/view/widgets/auth/sign/forms/email_form.dart';
import 'package:social_media_demo/view/widgets/auth/sign/buttons/google_button.dart';
import 'package:social_media_demo/view/widgets/auth/sign/forms/pass_form.dart';
import 'package:social_media_demo/view/widgets/auth/sign/buttons/sign_button.dart';
import 'package:social_media_demo/view/widgets/auth/sign/buttons/signup_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginCon loginCon = Get.put(LoginCon());
    return Scaffold(
      body: CustomColumn(
        fst: loginCon.fst,
        children: [
          const AppLogo(),
          const CustomText(
            text: 'Welcome Back',
            size: 25,
          ),
          const CustomText(
            text:
                'Sign In With Your Email And Password \n Or Login With Your Google Account',
            size: 18,
          ),
          SizedBox(height: AppDecoration().screenHeight * 0.03),
          const SignEmailForm(),
          const SignPassForm(),
          const SignUpButton(),
          const Expanded(child: SizedBox()),
          const GoogleSignButton(),
          const SignButton(),
          SizedBox(height: AppDecoration().screenHeight * 0.04),
        ],
      ),
    );
  }
}
