import 'package:sm_project/controller/chat/colors_controller.dart';
import 'package:sm_project/controller/chat/lifecycle.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/app_bar.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/chat_stream.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/custom_column.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/emojis.dart';
import 'package:sm_project/view/widgets/chat/chat_screen/text_form.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/controller/chat/privatemess_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivateChatScreen extends StatelessWidget {
  const PrivateChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PrivateChatsCon priv = Get.put(PrivateChatsCon());
    Get.put(ColorsController());
    Get.put(LifeCycle());
    return GetBuilder<ColorsController>(
      builder: (cC) => Scaffold(
        appBar: chatAppBar(),
        body: GetBuilder<LangCon>(
          builder: (c) => SafeArea(
            child: Column(
              children: [
                ChatStream(myUid: priv.myUid, friendUid: priv.friendUid),
                ChatCustomColumn(
                  [
                    priv.reply,
                    ChatTextForm(iconF: priv.iconF, myUid: priv.myUid),
                  ],
                ),
                EmojiWithWillpop(iconF: priv.iconF),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
