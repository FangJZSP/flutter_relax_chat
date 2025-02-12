import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/styles.dart';

class BasePage extends StatefulWidget {
  final String? pageTitle;
  final bool needLeading;
  final Widget? leadingWidget;
  final Color? appBarColor;
  final Color? backgroundColor;
  final Function()? onTapLeading;
  final Widget? mainContent;

  const BasePage({
    required this.needLeading,
    this.pageTitle,
    this.leadingWidget,
    this.appBarColor,
    this.backgroundColor,
    this.onTapLeading,
    this.mainContent,
    super.key,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // const MyImage(
        //   ImageNames.meBg,
        //   fit: BoxFit.fitWidth,
        // ),
        Scaffold(
          backgroundColor: widget.backgroundColor ?? Styles.white,
          appBar: AppBar(
            backgroundColor: widget.appBarColor ?? Styles.white,
            title:
                widget.pageTitle != null ? Text(widget.pageTitle ?? '') : null,
            leading: widget.needLeading ? _leadingWidget() : null,
          ),
          body: _body(),
        ),
      ],
    );
  }

  Widget _leadingWidget() {
    return widget.leadingWidget ??
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (widget.onTapLeading != null) {
              widget.onTapLeading?.call();
            } else {
              Get.back();
            }
          },
        );
  }

  Widget _body() {
    return Center(child: widget.mainContent ?? const Text('这里空空如也～'));
  }
}
