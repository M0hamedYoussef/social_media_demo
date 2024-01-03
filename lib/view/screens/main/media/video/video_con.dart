import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:video_player/video_player.dart';

class VideoCon extends GetxController {
  String? url;
  File? vidlocal;
  ChewieController? chewieController;
  VideoPlayerController? vidcon;
  @override
  void onClose() {
    super.onClose();
    if (chewieController != null &&
        chewieController!.videoPlayerController.value.isInitialized) {
      if (chewieController!.videoPlayerController.value.isInitialized) {
        chewieController!.videoPlayerController.dispose();
        chewieController!.dispose();
      }
    }
  }

  @override
  void onInit() {
    initVars();
    initVideo();
    super.onInit();
  }

  initVars() {
    url = Get.arguments['url'];
    vidlocal = Get.arguments['vidlocal'];
  }

  initVideo() {
    if (url != null) {
      vidcon = VideoPlayerController.networkUrl(Uri.parse(url!));
    } else if (vidlocal != null) {
      vidcon = VideoPlayerController.file(vidlocal!);
    }
    vidcon?.initialize().then(
      (_) {
        chewieController = ChewieController(
          videoPlayerController: vidcon!,
          aspectRatio: vidcon!.value.aspectRatio,
          controlsSafeAreaMinimum: EdgeInsets.zero,
          customControls: const MaterialControls(showPlayButton: true),
          allowFullScreen: true,
          autoPlay: false,
          autoInitialize: false,
          showControls: true,
          showControlsOnInitialize: false,
          looping: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.white,
            handleColor: AppColors.white,
            bufferedColor: Colors.grey,
          ),
          fullScreenByDefault: true,
          allowedScreenSleep: false,
          placeholder: const Center(
            child: CircularProgressIndicator(
              color: AppColors.white,
            ),
          ),
        );
        update();
      },
    );
  }
}
