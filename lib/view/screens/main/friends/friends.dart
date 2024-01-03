import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/controller/chat/friends_con.dart';
import 'package:sm_project/controller/global/lang_con.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:sm_project/view/screens/main/media/image/imagescreen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(FriendsCon());
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<FriendsCon>(builder: (controller) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.greyDesign,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GetBuilder<LangCon>(
                    builder: (langCon) => TextFormField(
                      textDirection: langCon.langTextField == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      controller: controller.searchCon,
                      focusNode: controller.searchFocus,
                      onEditingComplete: () {
                        controller.searchCompleted();
                      },
                      onChanged: (value) {
                        langCon.checkTextLang(value);
                        langCon.update();
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 9, horizontal: 27),
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (controller.friendModel != null)
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.friendModel!.userName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: InkWell(
                    onTap: () {
                      controller.addFriend();
                    },
                    child: const Icon(
                      Icons.add,
                      color: AppColors.darkBlue1,
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ImageScreen(
                          heroTag: controller.friendModel!.userID! +
                              controller.friendModel!.profilePicture!,
                          url: controller.friendModel!.profilePicture!,
                        ),
                        transition: Transition.downToUp,
                      );
                    },
                    child: Hero(
                      tag: controller.friendModel!.userID! +
                          controller.friendModel!.profilePicture!,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: CachedNetworkImageProvider(
                          controller.friendModel!.profilePicture!,
                        ),
                        backgroundColor: AppColors.black,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
