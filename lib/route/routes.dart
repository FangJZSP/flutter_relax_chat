import 'package:get/get.dart';
import 'package:relax_chat/pages/chat/chat_view.dart';
import '../pages/contact/contact_view.dart';
import '../pages/email_login/email_login_view.dart';
import '../pages/home/home_view.dart';
import '../pages/login/login_view.dart';
import '../pages/message/message_view.dart';
import '../pages/profile/profile_view.dart';
import '../pages/root/root_view.dart';

class Routes {
  static const root = '/';
  static const login = '/login';
  static const emailLogin = '/emailLogin';
  static const home = '/home';
  static const message = '/message';
  static const contact = '/contact';
  static const chat = '/chat';
  static const profile = '/profile';

  static List<GetPage> getPages = [
    GetPage(name: root, page: () => RootPage()),
    // 首页
    GetPage(name: home, page: () => HomePage(), popGesture: false),
    GetPage(name: message, page: () => MessagePage()),
    GetPage(name: contact, page: () => ContactPage()),
    // 登录
    GetPage(name: login, page: () => LoginPage(), popGesture: false),
    GetPage(name: emailLogin, page: () => EmailLoginPage()),
    // 聊天
    GetPage(name: chat, page: () => ChatPage()),
    // 信息
    GetPage(name: profile, page: () => ProfilePage()),
  ];
}
