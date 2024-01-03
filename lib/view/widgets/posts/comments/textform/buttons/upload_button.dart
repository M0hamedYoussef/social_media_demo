import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/controller/posts/comments_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsUploadButton extends StatelessWidget {
  const CommentsUploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    CommentsCon commentsCon = Get.put(CommentsCon());
    LangCon langCon = Get.put(LangCon());
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(60),
        onTap: () {
          Get.defaultDialog(
            title: 'Upload Media',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        Get.back();
                        await commentsCon.commentScreenImage();
                        langCon.update();
                      },
                      icon: const Icon(Icons.image),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    IconButton(
                      onPressed: () async {
                        Get.back();
                        await commentsCon.commentScreenVid(context);
                        langCon.update();
                      },
                      icon: const Icon(Icons.ondemand_video),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Image'),
                    SizedBox(
                      width: 55,
                    ),
                    Text('Video'),
                  ],
                ),
              ],
            ),
          );
        },
        child: const Icon(
          size: 25,
          Icons.perm_media,
        ),
      ),
    );
  }
}
