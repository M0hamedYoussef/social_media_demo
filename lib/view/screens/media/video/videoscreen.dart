import 'package:social_media_demo/view/screens/media/video/video_con.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VideoCon());
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: GetBuilder<VideoCon>(
          builder: (controller) {
            if (controller.chewieController == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
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
