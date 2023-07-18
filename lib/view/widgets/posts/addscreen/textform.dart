import 'dart:io';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/posts/posts_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPostsTextForm extends StatelessWidget {
  const AddPostsTextForm({super.key});

  @override
  Widget build(BuildContext context) {
    PostsCon postsCon = Get.put(PostsCon());
    ScrollController textFieldScrollController = ScrollController();
    LangCon langCon = Get.put(LangCon());
    return SingleChildScrollView(
      child: GetBuilder<LangCon>(
        builder: (c) => Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 100),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                prefixIcon: Column(
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        await postsCon.addScreenImage();
                        postsCon.vidImg = Image.file(
                          File(postsCon.addImagePath!),
                          fit: BoxFit.fill,
                        );
                        postsCon.update();
                      },
                      child: const Icon(Icons.image),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await postsCon.addScreenVid(context);
                      },
                      child: const Icon(Icons.ondemand_video),
                    ),
                  ],
                ),
              ),
              autocorrect: false,
              initialValue: postsCon.initVAL,
              minLines: 5,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              scrollController: textFieldScrollController,
              textDirection: langCon.langTextField == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              onChanged: (value) {
                textFieldScrollController
                    .jumpTo(textFieldScrollController.position.maxScrollExtent);
                langCon.checkTextLang(value);
                postsCon.initVAL = value;
                langCon.update();
              },
            ),
          ),
        ),
      ),
    );
  }
}
