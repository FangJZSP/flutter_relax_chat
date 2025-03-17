import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../common/size_config.dart';
import '../../../common/styles.dart';
import '../../../model/widget/message_cell_model.dart';

enum PressType {
  // 长按
  longPress,
  // 单击
  singleClick,
}

enum MessageActionType {
  copy,
  quote,
  pin,
  translate,
  retract,
  delete,
}

class PopupMenuParams {
  // 点击方式
  final PressType pressType;

  // 弹出菜单背景颜色
  final Color menuBgColor;

  // 菜单宽度
  final double menuWidth;

  // 菜单长度
  final double menuHeight;

  // 安全区域底部高度
  final double? bottomHeight;

  // 菜单展示回调
  final Function(MessageCellModel)? onMenuShow;

  // 根据消息类型获得功能列表
  final List<MessageActionType> Function(MessageCellModel) getActions;

  // 根据消息类型构建功能组件
  final Widget Function(
    MessageActionType,
    MessageCellModel,
    Function()? removePop,
  ) buildAction;

  PopupMenuParams({
    required this.onMenuShow,
    required this.getActions,
    required this.buildAction,
    required this.bottomHeight,
    this.pressType = PressType.longPress,
    this.menuBgColor = Styles.black,
    this.menuWidth = 250,
    this.menuHeight = 42,
  });
}

class PopupMenu extends StatefulWidget {
  final List<MessageActionType> actions;
  final Widget child;
  final PressType pressType;
  final Color menuBgColor;
  final double menuWidth;
  final double menuHeight;
  final Function()? onMenuShow;
  final double? bottomMargin;
  final Widget Function(MessageActionType, VoidCallback?)? buildAction;

  const PopupMenu({
    required this.child,
    required this.actions,
    required this.onMenuShow,
    required this.bottomMargin,
    this.pressType = PressType.longPress,
    this.menuBgColor = Colors.black,
    this.menuWidth = 250,
    this.menuHeight = 42,
    this.buildAction,
    super.key,
  });

  @override
  PopupMenuState createState() => PopupMenuState();
}

class PopupMenuState extends State<PopupMenu> {
  RenderBox? currentBox;
  RenderBox? overlay;
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        currentBox = context.findRenderObject() as RenderBox;
        overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    removeOverlay();
  }

  @override
  void didUpdateWidget(covariant PopupMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        currentBox = context.findRenderObject() as RenderBox;
        overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: widget.child,
      onTap: () {
        if (widget.pressType == PressType.singleClick) {
          showPopupMenu();
        }
      },
      onLongPress: () {
        if (widget.pressType == PressType.longPress) {
          showPopupMenu();
        }
      },
    );
  }

  void showPopupMenu() {
    if (widget.actions.isEmpty) {
      return;
    }
    Widget menuWidget = Material(
      color: Styles.transparent,
      child: _MenuPopWidget(
        widget.menuBgColor,
        currentBox!,
        overlay!,
        widget.actions,
        widget.buildAction,
        removePop: () {
          removeOverlay();
        },
      ),
    );
    entry = OverlayEntry(builder: (context) {
      return menuWidget;
    });
    Overlay.of(context).insert(entry!);
    widget.onMenuShow?.call();
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }
}

class _MenuPopWidget extends StatefulWidget {
  final Color backgroundColor;
  final RenderBox currentBox;
  final RenderBox overlay;
  final List<MessageActionType> actions;
  final Function()? removePop;
  final Widget Function(MessageActionType, VoidCallback?)? buildAction;

  const _MenuPopWidget(this.backgroundColor, this.currentBox, this.overlay,
      this.actions, this.buildAction,
      {this.removePop});

  @override
  _MenuPopWidgetState createState() => _MenuPopWidgetState();
}

class _MenuPopWidgetState extends State<_MenuPopWidget> {
  late Offset offset;
  late Size size;

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    offset =
        widget.currentBox.localToGlobal(Offset.zero, ancestor: widget.overlay);
    size = widget.currentBox.size;

    for (var element in widget.actions) {
      widgets.add(widget.buildAction?.call(element, widget.removePop) ??
          const SizedBox());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.removePop,
      child: Stack(alignment: Alignment.topCenter, children: [
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenWidth,
          color: Styles.transparent,
        ),
        Positioned(
          bottom: SizeConfig.screenHeight - offset.dy - 10.w,
          child: FadeIn(
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(4.w)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [...widgets],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
