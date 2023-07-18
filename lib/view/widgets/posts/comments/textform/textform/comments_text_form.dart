import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/global/obx_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class CommentsTextForm extends StatelessWidget {
  const CommentsTextForm({super.key, required this.focusNodeIcon});
  final FocusNode focusNodeIcon;
  @override
  Widget build(BuildContext context) {
    ObxCon obx = Get.put(ObxCon());
    LangCon langCon = Get.put(LangCon());
    ScrollController textFieldScrollController = ScrollController();
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 80),
        child: TextFormField(
          autocorrect: false,
          scrollController: textFieldScrollController,
          controller: obx.mess,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          focusNode: obx.f,
          textDirection: langCon.langTextField == 'en'
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          onChanged: (val) {
            textFieldScrollController
                .jumpTo(textFieldScrollController.position.maxScrollExtent);
            langCon.update();
            obx.mtcheck = val;
            val.isNotEmpty && val.length < 2
                ? langCon.checkTextLang(val.trim(),)
                : null;
            langCon.update();
          },
          onSaved: (newval) {
            obx.mtcheck = newval;
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black),
            ),
            prefixIcon: IconButton(
              focusNode: focusNodeIcon,
              onPressed: () {
                obx.f.canRequestFocus = true;
                obx.f.unfocus();
                obx.f.nextFocus();
                obx.changeemojivis();
              },
              icon: GetX<ObxCon>(
                builder: (controller) => Icon(
                  obx.emoji.value == true
                      ? Icons.keyboard
                      : Icons.emoji_emotions_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
