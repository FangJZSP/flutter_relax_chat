import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';
import 'package:relax_chat/widgets/chat_list/view/popup_widget.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../common/styles.dart';
import '../../../model/widget/message_cell_model.dart';
import '../controller/chat_controller.dart';
import '../controller/chat_scroll_physics.dart';

class ChatWidget extends StatefulWidget {
  /// 聊天控制器
  final ChatController chatController;

  /// 页面背景颜色
  final Color? backgroundColor;

  final Widget? toBottomFloatWidget;

  /// 消息展示方式
  final Function(BuildContext context, MessageCellModel model, int index)
      customeMessageCellBuilder;

  /// 自定义页头
  final Function(BuildContext context)? customHeadBuilder;

  /// 自定义置顶
  final Function(BuildContext context)? customPinBuilder;

  /// 自定义页尾
  final Function(BuildContext context)? customerBottomBuilder;

  /// 自定义列表的头
  final Function(BuildContext context)? onHeaderBuilder;

  /// 自定义右下角未读消息提示框，注意不需要有点击事件
  final Function(BuildContext context, int unReadCount)? unReadCountTipView;

  /// 刷新更多数据
  final Future Function()? onRefresh;

  /// 加载更多数据
  final Future Function()? onLoad;

  /// 点击背景
  /// 一般用于输入框焦点失去焦点
  final Function() onTapBg;

  /// 焦点 主要用于隐藏键盘
  final FocusNode inputTextFocusNode;

  /// 房间id
  final int roomId;

  final bool resizeToAvoidBottomInset;

  final bool showLoading;

  final VoidCallback? scrollListener;

  final Widget? loadingView;

  final double? cacheExtent;

  final Offset? floatTipOffset;

  final Widget? lastViewedTipView;

  final Widget? msgListOverlay;

  /// 由于列表是反转的，[refreshHeader] 实际类型是 [Footer]
  final Footer? refreshHeader;

  final PopupMenuParams? menuParams;

  const ChatWidget(
      {required this.onLoad,
      required this.onRefresh,
      required this.customeMessageCellBuilder,
      required this.inputTextFocusNode,
      required this.chatController,
      required this.roomId,
      required this.onTapBg,
      this.customHeadBuilder,
      this.toBottomFloatWidget,
      super.key,
      this.menuParams,
      this.backgroundColor,
      this.unReadCountTipView,
      this.customerBottomBuilder,
      this.customPinBuilder,
      this.resizeToAvoidBottomInset = false,
      this.onHeaderBuilder,
      this.showLoading = false,
      this.loadingView,
      this.cacheExtent,
      this.scrollListener,
      this.floatTipOffset,
      this.msgListOverlay,
      this.lastViewedTipView,
      this.refreshHeader});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget>
    with AutomaticKeepAliveClientMixin {
  late ChatController chatController;

  final LayerLink layerLink = LayerLink();

  BuildContext? pageOverlayContext;

  int get roomId => widget.roomId;

  final GlobalKey headerKey = GlobalKey();

  /// 顶部间距，loading时，把header部分留出来，可以进行退出页面或其他操作
  double? topMargin;

  /// 消息列表是否已完成初始化拉取，防止列表为空时，一直显示loading动画
  bool showLoading = false;

  /// 下拉加载消息时，为了列表不跳到底部，需要给一个较大的cacheExtent
  final ValueNotifier<double> _cacheExtent = ValueNotifier<double>(1000);

  double? scrollExtent;

  List<BuildContext> sliverListContexts = [];

  @override
  void initState() {
    super.initState();
    showLoading = widget.showLoading;
    chatController = widget.chatController;
    chatController.init(update: update, ctx: context);
    chatController.scrollController.addListener(scrollControllerListener);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      addUnreadTipView();
      RenderBox? box =
          headerKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        topMargin = box.size.height + box.globalToLocal(Offset.zero).dy;
        update();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {
        chatController.checkIfNeedShowJumpToBottom();
        if (scrollExtent == null || scrollExtent! <= screenHeight) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (chatController.observerController.scrollExtent != null) {
              scrollExtent = chatController.observerController.scrollExtent;
              setState(() {});
            }
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(ChatWidget oldWidget) {
    showLoading = widget.showLoading;
    super.didUpdateWidget(oldWidget);
  }

  void scrollControllerListener() {
    if (chatController.scrollController.offset < 50) {
      chatController.updateUnreadMsgCount(isReset: true);
    }
    chatController.checkIfNeedShowJumpToBottom();
    widget.scrollListener?.call();
  }

  /// 显示未读消息条数提示
  void addUnreadTipView() {
    Overlay.of(pageOverlayContext!).insert(OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          followerAnchor: Alignment.bottomRight,
          targetAnchor: Alignment.topRight,
          offset: widget.floatTipOffset ?? const Offset(-20, -20),
          child: Material(
            type: MaterialType.transparency,
            child: _buildFloatTipView(),
          ),
        ),
      ),
    ));
  }

  void _onRefresh() async {
    _cacheExtent.value = 5000;
    await widget.onRefresh?.call();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _cacheExtent.value = 1000;
    });
  }

  void _onLoad() async {
    await widget.onLoad?.call();
  }

  Widget _buildFloatTipView() {
    return Obx(() {
      return Visibility(
        visible: chatController.showJumpToBottom.value,
        child: Obx(() {
          if (chatController.unreadMsgCount.value == 0 &&
              (chatController.showJumpToBottom.value ||
                  chatController.cachedMessageList.isNotEmpty)) {
            return GestureDetector(
              onTap: chatController.scrollToBottom,
              child: _buildToBottomView(context),
            );
          }

          if (chatController.unreadMsgCount.value == 0) {
            return SizedBox.fromSize();
          }
          return GestureDetector(
            onTap: chatController.scrollToFirstUnreadMessage,
            child: _buildUnreadTipView(
                context, chatController.unreadMsgCount.value),
          );
        }),
      );
    });
  }

  Widget _buildToBottomView(BuildContext context) {
    return widget.toBottomFloatWidget ??
        Icon(
          Icons.arrow_drop_down_circle_outlined,
          size: 40.w,
          color: Styles.white,
          shadows: [
            BoxShadow(
              // 阴影颜色
              color: Colors.black.withOpacity(0.5),
              // 阴影扩散范围
              spreadRadius: 2,
              // 阴影模糊范围
              blurRadius: 4,
              // 阴影偏移量
              offset: const Offset(0, 0),
            ),
          ],
        );
  }

  Widget _buildUnreadTipView(BuildContext context, int value) {
    return widget.unReadCountTipView?.call(context, value) ??
        const Text('消息未读');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: GestureDetector(
        onTap: widget.onTapBg,
        behavior: HitTestBehavior.opaque,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildContent(),
        _buildPageOverlay(),
        Positioned(
          top: (topMargin ?? 0) + 40,
          right: 0,
          child: Obx(() => Visibility(
                visible: chatController.lastViewedMessageId.value != null &&
                    !chatController.hasReadLastViewedMessage.value,
                child: widget.lastViewedTipView ?? const SizedBox(),
              )),
        ),
        Positioned(
          top: topMargin ?? 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Visibility(
            visible: showLoading,
            child: Container(
              color: widget.backgroundColor ?? Colors.white,
              child: Center(
                child: widget.loadingView ??
                    const CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageOverlay() {
    return Overlay(initialEntries: [
      OverlayEntry(
        builder: (context) {
          pageOverlayContext = context;
          return Container();
        },
      )
    ]);
  }

  Widget _buildContent() {
    return Column(
      children: [
        Container(
          key: headerKey,
          child: widget.customHeadBuilder?.call(context),
        ),
        widget.customPinBuilder?.call(context) ?? const SizedBox(),
        Flexible(
            child: Stack(
          children: [
            _buildListView(),
            if (widget.msgListOverlay != null) widget.msgListOverlay!
          ],
        )),
        CompositedTransformTarget(
          link: layerLink,
          child: Container(),
        ),
        widget.customerBottomBuilder?.call(context) ?? const SizedBox(),
      ],
    );
  }

  Widget _buildListView() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Listener(
        onPointerMove: (_) {
          widget.onTapBg();
        },
        child: ListViewObserver(
          controller: chatController.observerController,
          onObserve: (ListViewObserveModel model) {
            chatController
                .updateDisplayingChildIndexList(model.displayingChildIndexList);
          },
          sliverListContexts: () {
            return sliverListContexts;
          },
          child: EasyRefresh.builder(
            childBuilder: (context, physics) {
              return _buildListViewContent(constraints, physics);
            },
            footer: widget.refreshHeader ?? const MaterialFooter(),
            controller: chatController.easyRefreshController,
            onLoad: widget.onLoad == null ? null : _onLoad,
            onRefresh: widget.onRefresh == null ? null : _onRefresh,
          ),
        ),
      );
    });
  }

  Widget _buildListViewContent(
      BoxConstraints constraints, ScrollPhysics physics) {
    bool shrinkWrap = chatController.chatObserver.isShrinkWrap;
    if (scrollExtent != null && scrollExtent! <= screenHeight) {
      shrinkWrap = true;
    }
    Widget child = ValueListenableBuilder<double?>(
        valueListenable: _cacheExtent,
        builder: (context, value, child) {
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: physics.applyTo(ChatClampingScrollPhysics(
                observer: chatController.chatObserver)),
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
            ),
            shrinkWrap: shrinkWrap,
            reverse: true,
            controller: chatController.scrollController,
            cacheExtent: widget.cacheExtent ?? value,
            itemBuilder: ((context, index) {
              if (index == 0) {
                sliverListContexts.clear();
              }
              sliverListContexts.add(context);
              if (index == chatController.showedMessageList.length &&
                  widget.onHeaderBuilder != null) {
                return widget.onHeaderBuilder?.call(context);
              }
              MessageCellModel chatModel =
                  chatController.showedMessageList[index];
              if (widget.menuParams == null) {
                return widget.customeMessageCellBuilder
                    .call(context, chatModel, index);
              }
              return WPopupMenu(
                child: widget.customeMessageCellBuilder
                    .call(context, chatModel, index),
                actions: widget.menuParams!.getActions.call(chatModel),
                onMenuShow: () =>
                    widget.menuParams!.onMenuShow?.call(chatModel),
                onSingleTap: widget.menuParams!.onSingleTap,
                bottomMargin: widget.menuParams!.bottomHeight,
                pressType: widget.menuParams!.pressType,
                backgroundColor: widget.menuParams!.backgroundColor,
                menuWidth: widget.menuParams!.menuWidth,
                menuHeight: widget.menuParams!.menuHeight,
                buildAction: (type, removePop) =>
                    widget.menuParams!.onAction(type, chatModel, removePop),
              );
            }),
            itemCount: dataCount,
          );
        });
    if (shrinkWrap) {
      child = SingleChildScrollView(
        reverse: true,
        physics: physics,
        child: Container(
          alignment: Alignment.topCenter,
          height: constraints.maxHeight + 0.001,
          child: child,
        ),
      );
    }
    return child;
  }

  int get dataCount {
    int h = null == widget.onHeaderBuilder ? 0 : 1;
    return chatController.showedMessageList.length + h;
  }

  @override
  bool get wantKeepAlive => true;
}
