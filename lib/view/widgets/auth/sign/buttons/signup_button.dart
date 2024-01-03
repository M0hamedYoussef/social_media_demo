import 'package:sm_project/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Don\'t Have An Account ?',
            style: TextStyle(
              color: AppColors.darkBlue1,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.reg);
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: AppColors.darkBlue1.withOpacity(0.7),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
