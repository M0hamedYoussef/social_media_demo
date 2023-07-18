import 'package:social_media_demo/core/midleware/midleware.dart';
import 'package:social_media_demo/view/screens/main/auth/reg.dart';
import 'package:social_media_demo/view/screens/main/auth/sign.dart';
import 'package:social_media_demo/view/screens/main/chatscreen/friends_screen.dart';
import 'package:social_media_demo/view/screens/main/chatscreen/privatechat.dart';
import 'package:social_media_demo/view/screens/main/posts/comments.dart';
import 'package:social_media_demo/view/screens/main/posts/posts.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static const sign = '/sign';
  static const reg = '/reg';
  static const main = '/main';
  static const privates = '/privates';
  static const privateChat = '/privateChat';
  static const comments = '/comments';
}

List<GetPage<dynamic>> appRoutes = [
  GetPage(
    name: AppRoutes.sign,
    page: () => const SignScreen(),
    middlewares: [
      AppMiddleware(),
    ],
  ),
  GetPage(name: AppRoutes.reg, page: () => const RegScreen()),
  GetPage(name: AppRoutes.main, page: () => const MainScreen()),
  GetPage(name: AppRoutes.privates, page: () => const PrivateFriends()),
  GetPage(name: AppRoutes.privateChat, page: () => const PrivateChatScreen()),
  GetPage(name: AppRoutes.comments, page: () => const CommentsScreen()),
];
