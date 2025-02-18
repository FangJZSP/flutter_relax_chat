import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../model/widget/message_cell_model.dart';

const double _kMenuScreenPadding = 0;

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
}

double get screenWidth =>
    PlatformDispatcher.instance.views.first.physicalSize.width /
    PlatformDispatcher.instance.views.first.devicePixelRatio;

double get screenHeight =>
    PlatformDispatcher.instance.views.first.physicalSize.height /
    PlatformDispatcher.instance.views.first.devicePixelRatio;

double get statusBarHeight =>
    PlatformDispatcher.instance.views.first.padding.top /
    PlatformDispatcher.instance.views.first.devicePixelRatio;

double get bottomPadding =>
    PlatformDispatcher.instance.views.first.padding.bottom /
    PlatformDispatcher.instance.views.first.devicePixelRatio;

class PopupMenuParams {
  PopupMenuParams({
    required this.onMenuShow,
    required this.bottomHeight,
    required this.getActions,
    required this.onAction,
    this.pressType = PressType.longPress,
    this.backgroundColor = Colors.black,
    this.menuWidth = 250,
    this.menuHeight = 42,
    this.onSingleTap,
  });

  final PressType pressType; // 点击方式 长按 还是单击
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;
  final Widget Function(
      MessageActionType, MessageCellModel, VoidCallback? removePop) onAction;
  final Function()? onSingleTap;
  final double? bottomHeight;
  final List<MessageActionType> Function(MessageCellModel) getActions;
  final Function(MessageCellModel)? onMenuShow;
}

class WPopupMenu extends StatefulWidget {
  const WPopupMenu({
    required this.child,
    required this.actions,
    required this.onMenuShow,
    required this.bottomMargin,
    super.key,
    this.pressType = PressType.longPress,
    this.backgroundColor = Colors.black,
    this.menuWidth = 250,
    this.menuHeight = 42,
    this.onSingleTap,
    this.buildAction,
  });

  final List<MessageActionType> actions;
  final Widget child;
  final PressType pressType; // 点击方式 长按 还是单击
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;
  final Function()? onSingleTap;
  final VoidCallback onMenuShow;
  final double? bottomMargin;
  final Widget Function(MessageActionType, VoidCallback?)? buildAction;

  @override
  WPopupMenuState createState() => WPopupMenuState();
}

class WPopupMenuState extends State<WPopupMenu> {
  double? width;
  double? height;
  RenderBox? button;
  RenderBox? overlay;
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        width = context.size?.width;
        height = context.size?.height;
        button = context.findRenderObject() as RenderBox;
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
  void didUpdateWidget(covariant WPopupMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        width = context.size?.width;
        height = context.size?.height;
        button = context.findRenderObject() as RenderBox;
        overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        removeOverlay();
        return Future.value(true);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: widget.child,
        onTap: () {
          if (widget.pressType == PressType.singleClick) {
            onTap();
          }
          widget.onSingleTap?.call();
        },
        onLongPress: () {
          if (widget.pressType == PressType.longPress) {
            onTap();
          }
        },
      ),
    );
  }

  void onTap() {
    if (widget.actions.isEmpty) {
      return;
    }
    Widget menuWidget = _MenuPopWidget(
      context,
      height!,
      width!,
      widget.backgroundColor,
      widget.menuWidth,
      widget.menuHeight,
      button!,
      overlay!,
      widget.actions,
      widget.bottomMargin,
      widget.buildAction,
      removePop: () {
        removeOverlay();
      },
    );

    entry = OverlayEntry(builder: (context) {
      return menuWidget;
    });
    Overlay.of(context).insert(entry!);
    widget.onMenuShow.call();
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }
}

class _MenuPopWidget extends StatefulWidget {
  final BuildContext btnContext;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;
  final double _height;
  final double _width;
  final RenderBox button;
  final RenderBox overlay;
  final List<MessageActionType> actions;
  final Function()? removePop;
  final double? bottomMargin;
  final Widget Function(MessageActionType, VoidCallback?)? buildAction;

  const _MenuPopWidget(
      this.btnContext,
      this._height,
      this._width,
      this.backgroundColor,
      this.menuWidth,
      this.menuHeight,
      this.button,
      this.overlay,
      this.actions,
      this.bottomMargin,
      this.buildAction,
      {this.removePop});

  @override
  _MenuPopWidgetState createState() => _MenuPopWidgetState();
}

class _MenuPopWidgetState extends State<_MenuPopWidget> {
  late RelativeRect position;

  List<Widget> widgets = [];

  double popWidth = 0;

  @override
  void initState() {
    super.initState();
    position = RelativeRect.fromRect(
      Rect.fromPoints(
        widget.button.localToGlobal(Offset.zero, ancestor: widget.overlay),
        widget.button.localToGlobal(Offset.zero, ancestor: widget.overlay),
      ),
      Offset.zero & widget.overlay.size,
    );

    for (var element in widget.actions) {
      widgets.add(widget.buildAction?.call(element, widget.removePop) ??
          const SizedBox());
      popWidth += 70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.removePop,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: Builder(
          builder: (BuildContext context) {
            bool isInverted = (position.top +
                    (MediaQuery.of(context).size.height -
                            position.top -
                            position.bottom) /
                        2.0 -
                    widget.menuHeight) <=
                2 * widget.menuHeight;

            if (isInverted &&
                position.top + widget._height >
                    MediaQuery.of(context).size.height -
                        (widget.bottomMargin ?? 0)) {
              isInverted = false;
            }

            return CustomSingleChildLayout(
              // 这里计算偏移量
              delegate: _PopupMenuRouteLayout(
                  position,
                  widget.menuHeight,
                  Directionality.of(widget.btnContext),
                  widget._width,
                  popWidth,
                  widget._height,
                  widget.bottomMargin),
              child: SizedBox(
                height: widget.menuHeight,
                width: popWidth,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    color: const Color.fromRGBO(102, 102, 102, 1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widgets,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
      this.position,
      this.selectedItemOffset,
      this.textDirection,
      this.width,
      this.menuWidth,
      this.height,
      this.bottomMargin);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The distance from the top of the menu to the middle of selected item.
  //
  // This will be null if there's no item to position in this way.
  final double? selectedItemOffset;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  final double width;
  final double height;
  final double menuWidth;

  final double? bottomMargin;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    Offset offset =
        const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0);
    return BoxConstraints.loose(Size(constraints.biggest.width - offset.dx,
        constraints.biggest.height - offset.dy));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y;
    if (selectedItemOffset == null) {
      y = position.top;
    } else {
      y = position.top +
          (size.height - position.top - position.bottom) / 2.0 -
          selectedItemOffset!;
    }

    // Find the ideal horizontal position.
    double x;

    // 如果menu 的宽度 小于 child 的宽度，则直接把menu 放在 child 中间
    if (childSize.width < width) {
      x = position.left + (width - childSize.width) / 2;
    } else {
      // 如果靠右
      if (position.left > size.width - (position.left + width)) {
        if (size.width - (position.left + width) >
            childSize.width / 2 + _kMenuScreenPadding) {
          x = position.left - (childSize.width - width) / 2;
        } else {
          x = position.left + width - childSize.width;
        }
      } else if (position.left < size.width - (position.left + width)) {
        if (position.left > childSize.width / 2 + _kMenuScreenPadding) {
          x = position.left - (childSize.width - width) / 2;
        } else {
          x = position.left;
        }
      } else {
        x = position.right - width / 2 - childSize.width / 2;
      }
    }

    bool isInverted = (position.top +
            (size.height - position.top - position.bottom) / 2.0 -
            childSize.height) <=
        2 * childSize.height;

    if (isInverted &&
        position.top + height > size.height - (bottomMargin ?? 0)) {
      isInverted = false;
    }

    if (position.top > statusBarHeight + 44 &&
        (height + position.top) > size.height) {
      isInverted = false;
    }

    if (y < _kMenuScreenPadding + statusBarHeight + 44) {
      if (position.top + height >
          size.height - (bottomMargin ?? 0) - _kMenuScreenPadding) {
        y = (position.top + position.bottom) / 2 - childSize.height;
      } else {
        y = position.top + height;
      }
    } else if (y + childSize.height >
        size.height - (bottomMargin ?? 0) - _kMenuScreenPadding) {
      if (position.top + childSize.height > 0) {
        y = _kMenuScreenPadding + statusBarHeight + 44;
      } else {
        y = size.height - (bottomMargin ?? 0) - childSize.height;
      }
    } else if (y < childSize.height * 2) {
      y = position.top + height;
      if (y < _kMenuScreenPadding + statusBarHeight + 44) {
        y = _kMenuScreenPadding + statusBarHeight + 44;
      } else if (position.top + childSize.height >
              _kMenuScreenPadding + statusBarHeight + 44 &&
          !isInverted) {
        y = position.top - childSize.height;
      } else if (y + childSize.height > size.height - _kMenuScreenPadding) {
        y = size.height - childSize.height;
      }
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}
