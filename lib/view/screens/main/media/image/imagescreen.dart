import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sm_project/controller/global/download_controller.dart';
import 'package:sm_project/core/const/colors.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key, required this.url, required this.heroTag});
  final String url;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    DownloadFiles dowanloder = Get.put(DownloadFiles());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        actions: [
          IconButton(
            onPressed: () {
              dowanloder.downloadFile(url: url);
            },
            icon: const Icon(
              Icons.download,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.black,
      body: Hero(
        tag: heroTag,
        child: SafeArea(
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              Get.back();
            },
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(url),
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
