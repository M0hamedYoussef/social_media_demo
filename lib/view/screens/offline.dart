import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/const/decoration.dart';
import 'package:sm_project/core/const/image_asset.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                        bottom: 22,
                      ),
                      child: Lottie.asset(
                        AppImageAsset.noConnectionLottie,
                        width: AppDecoration().screenWidth * .8,
                        frameRate: FrameRate(90),
                      ),
                    ),
                  ),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue1,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue1,
                        foregroundColor: AppColors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Restart'),
                      onPressed: () {
                        Restart.restartApp();
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue1,
                        foregroundColor: AppColors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Exit'),
                      onPressed: () {
                        exit(0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
