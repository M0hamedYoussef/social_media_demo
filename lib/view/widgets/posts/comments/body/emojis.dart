import 'package:sm_project/controller/global/obx_con.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';

class CommentsEmoji extends StatelessWidget {
  const CommentsEmoji(
      {super.key, required this.fst, required this.focusNodeIcon});
  final GlobalKey<FormState> fst;
  final FocusNode focusNodeIcon;
  @override
  Widget build(BuildContext context) {
    ObxCon obx = Get.put(ObxCon());

    return WillPopScope(
      onWillPop: () {
        if (obx.emoji.value) {
          obx.emoji.value = false;
          focusNodeIcon.unfocus();
        } else {
          Get.back();
        }
        return Future.value(false);
      },
      child: Obx(
        () => Offstage(
          offstage: !obx.emoji.value,
          child: SizedBox(
            height: 232,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                fst.currentState!.save();
              },
              textEditingController: obx.mess,
              config: const Config(
                columns: 7,
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: Color(0xFFF2F2F2),
                indicatorColor: AppColors.black,
                iconColor: AppColors.black,
                iconColorSelected: AppColors.black,
                backspaceColor: AppColors.black,
                skinToneDialogBgColor: AppColors.white,
                skinToneIndicatorColor: AppColors.black,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                noRecents: Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: AppColors.black26),
                  textAlign: TextAlign.center,
                ),
                loadingIndicator: SizedBox.shrink(),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
