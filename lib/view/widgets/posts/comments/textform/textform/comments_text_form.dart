import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/controller/global/obx_con.dart';
import 'package:sm_project/core/const/colors.dart';
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
          focusNode: obx.textFormFocus,
          textDirection: langCon.langTextField == 'en'
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          onChanged: (val) {
            textFieldScrollController
                .jumpTo(textFieldScrollController.position.maxScrollExtent);
            langCon.update();
            val.isNotEmpty && val.length < 2
                ? langCon.checkTextLang(
                    val.trim(),
                  )
                : null;
            langCon.update();
          },
        
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            prefixIcon: IconButton(
              focusNode: focusNodeIcon,
              onPressed: () {
                obx.textFormFocus.canRequestFocus = true;
                obx.textFormFocus.unfocus();
                obx.textFormFocus.nextFocus();
                obx.changeemojivis();
              },
              icon: GetX<ObxCon>(
                builder: (controller) => Icon(
                  obx.emoji.value == true
                      ? Icons.keyboard
                      : Icons.emoji_emotions_outlined,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
