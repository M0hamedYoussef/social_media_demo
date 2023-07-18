import 'package:social_media_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.reg);
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                  color: Colors.black, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
