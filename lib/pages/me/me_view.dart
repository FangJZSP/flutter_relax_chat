import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'me_logic.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> with TickerProviderStateMixin {
  final logic = Get.put(MeLogic());
  final state = Get.find<MeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
