import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_media_demo/controller/chat/privatemess_con.dart';
import 'package:social_media_demo/view/screens/media/image/imagescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSizeWidget chatAppBar() {
  PrivateChatsCon priv = Get.find();

  return AppBar(
    leading: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () async {
            Get.back();
            priv.setOutOfChat();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => ImageScreen(
                  url: priv.friendPFP,
                  heroTag: priv.friendUid + priv.friendPFP,
                ),
                transition: Transition.downToUp,
              );
            },
            child: Hero(
              tag: priv.friendUid + priv.friendPFP,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(priv.friendPFP),
                backgroundColor: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.white,
    elevation: 2,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          priv.friendName,
          style: const TextStyle(color: Colors.black),
        ),
        StreamBuilder(
          stream: priv.friendStatusInMY!.snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.data() != null) {
                if (snapshot.data!.data().toString().substring(
                        9, snapshot.data!.data().toString().length - 1) ==
                    'In Chat') {
                  return Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 4,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        snapshot.data!.data().toString().substring(
                            9, snapshot.data!.data().toString().length - 1),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  );
                } else if (snapshot.data!.data().toString().substring(
                        9, snapshot.data!.data().toString().length - 1) ==
                    'Typing ...') {
                  return Text(
                    snapshot.data!.data().toString().substring(
                        9, snapshot.data!.data().toString().length - 1),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  );
                } else if (snapshot.data!
                    .data()
                    .toString()
                    .substring(9, snapshot.data!.data().toString().length - 1)
                    .contains('Sending')) {
                  return Text(
                    snapshot.data!.data().toString().substring(
                        9, snapshot.data!.data().toString().length - 1),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  );
                } else if (snapshot.data!
                        .data()
                        .toString()
                        .substring(
                            9, snapshot.data!.data().toString().length - 1)
                        .trim() ==
                    '') {
                  return const Text(
                    'Disconnected',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  );
                }
              } else {
                return const Text(
                  'Disconnected',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                );
              }
            }

            return const Text('');
          }),
        ),
      ],
    ),
  );
}
