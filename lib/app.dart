import 'package:bot_toast/bot_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:relax_chat/route/my_route_observer.dart';
import 'package:get/get.dart';
import 'package:relax_chat/route/routes.dart';

import 'common/styles.dart';

class RelaxChatApp extends StatelessWidget {
  const RelaxChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
    EasyRefresh.defaultFooterBuilder = () => const MaterialFooter();

    return GetMaterialApp(
      title: 'Relaxing',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver(), MyRouteObserver()],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Styles.normalBlue),
        useMaterial3: true,
      ),
      initialRoute: Routes.root,
      getPages: Routes.getPages,
    );
  }
}
