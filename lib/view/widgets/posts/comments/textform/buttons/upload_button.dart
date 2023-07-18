import 'dart:io';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/posts/comments_con.dart';
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
                        commentsCon.bottomWid = SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Image.file(
                                    File(
                                      commentsCon.addImagePath.toString(),
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text('Send Image',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                        commentsCon.update();
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
