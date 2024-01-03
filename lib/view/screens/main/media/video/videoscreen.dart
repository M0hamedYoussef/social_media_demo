import 'package:sm_project/controller/global/download_controller.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/view/screens/main/media/video/video_con.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VideoCon videoCon = Get.put(VideoCon());
    DownloadFiles dowanloder = Get.put(DownloadFiles());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        actions: [
          if (videoCon.url != null)
            IconButton(
              onPressed: () {
                dowanloder.downloadFile(url: videoCon.url!);
              },
              icon: const Icon(
                Icons.download,
              ),
            ),
        ],
      ),
      body: Container(
        color: AppColors.black,
        child: GetBuilder<VideoCon>(
          builder: (controller) {
            if (controller.chewieController == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              );
            } else {
              controller.chewieController?.videoPlayerController.play();
              return Chewie(
                controller: controller.chewieController!,
              );
            }
          },
        ),
      ),
    );
  }
}
