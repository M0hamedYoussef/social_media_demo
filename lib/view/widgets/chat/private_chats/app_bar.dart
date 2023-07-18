import 'package:social_media_demo/core/const/image_asset.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget privatesAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    leading: const CircleAvatar(
      backgroundImage: AssetImage(AppImageAsset.appLogo),
      backgroundColor: Colors.transparent,
      radius: 5,
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Text(
              'Chats',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
