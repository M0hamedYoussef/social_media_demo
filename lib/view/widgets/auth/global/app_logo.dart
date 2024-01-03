import 'package:sm_project/core/const/decoration.dart';
import 'package:sm_project/core/const/image_asset.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: SizedBox(
        height: AppDecoration().screenHeight * 0.25,
        child: const Image(
          image: AssetImage(AppImageAsset.appLogo),
        ),
      ),
    );
  }
}
