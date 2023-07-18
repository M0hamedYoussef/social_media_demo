import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/controller/global/obx_con.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmojiWithWillpop extends StatelessWidget {
  const EmojiWithWillpop({super.key, required this.fst, required this.iconF});
  final GlobalKey<FormState> fst;
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
                indicatorColor: Colors.black,
                iconColor: Colors.black,
                iconColorSelected: Colors.black,
                backspaceColor: Colors.black,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.black,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                noRecents: Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
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
