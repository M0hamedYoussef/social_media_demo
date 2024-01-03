import 'package:sm_project/core/midleware/midleware.dart';
import 'package:sm_project/view/screens/main/auth/reg.dart';
import 'package:sm_project/view/screens/main/auth/sign.dart';
import 'package:sm_project/view/screens/main/chatscreen/friends_screen.dart';
import 'package:sm_project/view/screens/main/chatscreen/privatechat.dart';
import 'package:sm_project/view/screens/main/posts/comments.dart';
import 'package:sm_project/view/screens/main/main/main_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:sm_project/view/screens/offline.dart';
import 'package:sm_project/view/screens/profile/profile_screen.dart';

class AppRoutes {
  static const sign = '/sign';
  static const reg = '/reg';
  static const main = '/main';
  static const profile = '/profile';
  static const privates = '/privates';
  static const privateChat = '/privateChat';
  static const comments = '/comments';
  //
  static const offline = '/offline';
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
  GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
  GetPage(name: AppRoutes.privates, page: () => const PrivateFriends()),
  GetPage(name: AppRoutes.privateChat, page: () => const PrivateChatScreen()),
  GetPage(name: AppRoutes.comments, page: () => const CommentsScreen()),
  //
  GetPage(name: AppRoutes.offline, page: () => const OfflineScreen()),
];
