import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:sm_project/controller/global/obx_con.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/core/const/decoration.dart';

class EmojiWithWillpop extends StatelessWidget {
  const EmojiWithWillpop({super.key, required this.iconF});
  final FocusNode iconF;
  @override
  Widget build(BuildContext context) {
    ObxCon obx = Get.put(ObxCon());
    PrivateChatsCon priv = Get.put(PrivateChatsCon());

    return WillPopScope(
      onWillPop: () async {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        if (obx.emoji.value) {
          obx.emoji.value = false;
          iconF.unfocus();
        } else {
          Get.back();
          batch.set(priv.myStatusInFriend!, {'status': ''});
          await batch.commit();
        }
        return Future.value(false);
      },
      child: Obx(
        () => Offstage(
          offstage: !obx.emoji.value,
          child: SizedBox(
            height: AppDecoration().screenHeight * 0.3,
            child: EmojiPicker(
              textEditingController: obx.mess,
              onBackspacePressed: () {},
              config: const Config(
                columns: 7,
                emojiSet: defaultEmojiSet,
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
