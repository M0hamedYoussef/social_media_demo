import 'package:social_media_demo/controller/auth/login_con.dart';
import 'package:social_media_demo/core/const/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleSignButton extends StatelessWidget {
  const GoogleSignButton({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginCon loginCon = Get.find();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () async {
            loginCon.googleSign();
          },
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Image.asset(
                  AppImageAsset.googleButton,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const Text(
                'Login With Google',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
