import 'package:get/get.dart';
import 'package:relax_chat/pages/apply/apply_view.dart';
import 'package:relax_chat/pages/chat/chat_view.dart';
import '../pages/add/add_view.dart';
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
  static const add = '/add';
  static const apply = '/apply';

  static List<GetPage> getPages = [
    GetPage(name: root, page: () => RootPage()),

    /// 首页
    GetPage(name: home, page: () => HomePage(), popGesture: false),

    /// 消息
    GetPage(name: message, page: () => MessagePage()),

    /// 联系人
    GetPage(name: contact, page: () => ContactPage()),

    /// 登录页
    GetPage(name: login, page: () => LoginPage(), popGesture: false),

    /// 邮箱登录
    GetPage(name: emailLogin, page: () => EmailLoginPage()),

    /// 聊天
    GetPage(name: chat, page: () => ChatPage()),

    /// 个人资料
    GetPage(name: profile, page: () => ProfilePage()),

    /// 搜索好友/群聊
    GetPage(name: add, page: () => AddPage()),

    /// 申请好友/群聊
    GetPage(name: apply, page: () => ApplyPage()),
  ];
}
