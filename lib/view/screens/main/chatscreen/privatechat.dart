import 'package:social_media_demo/controller/chat/lifecycle.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/app_bar.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/chat_stream.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/custom_column.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/emojis.dart';
import 'package:social_media_demo/view/widgets/chat/chat_screen/text_form.dart';
import 'package:social_media_demo/controller/global/lang_con.dart';
import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivateChatScreen extends StatelessWidget {
  const PrivateChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PrivateChatsCon priv = Get.put(PrivateChatsCon());
    Get.put(LifeCycle());
    return Scaffold(
      appBar: chatAppBar(),
      body: GetBuilder<LangCon>(
        builder: (c) => Form(
          key: priv.fst,
          child: SafeArea(
            child: Column(
              children: [
                ChatStream(myUid: priv.myUid, friendUid: priv.friendUid),
                ChatCustomColumn(
                  [
                    priv.reply,
                    ChatTextForm(iconF: priv.iconF, myUid: priv.myUid),
                  ],
                ),
                EmojiWithWillpop(fst: priv.fst, iconF: priv.iconF),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
