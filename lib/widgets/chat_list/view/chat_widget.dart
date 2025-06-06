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

class ChatWidget extends StatefulWidget {
  /// 聊天控制器
  final ChatController chatController;

  /// 页面背景颜色
  final Color? backgroundColor;

  /// 消息展示方式
  final Function(BuildContext context, MessageCellModel model, int index)
      customMessageCellBuilder;

  /// 自定义页头
  final Function(BuildContext context)? customHeadBuilder;

  /// 自定义置顶
  final Function(BuildContext context)? customPinBuilder;

  /// 自定义页尾
  final Function(BuildContext context)? customBottomBuilder;

  /// 自定义列表的头
  final Function(BuildContext context)? customListHeadBuilder;

  /// 自定义跳转底部组件
  final Function(BuildContext context)? customJumpBottomFloatBuilder;

  /// 自定义未读消息提示框，注意不需要有点击事件
  final Function(BuildContext context, int unReadCount)?
      unreadCountFloatBuilder;

  /// 刷新最新数据
  final Future Function()? onRefresh;

  /// 加载更多数据
  final Future Function()? onLoad;

  /// 由于列表是反转的，[refreshHeader] 实际类型是 [Footer]
  final Footer? refreshHeader;

  /// 由于列表是反转的，[refreshFooter] 实际类型是 [Header]
  final Header? refreshFooter;

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

  final PopupMenuParams? popupMenuParams;

  const ChatWidget({
    required this.customMessageCellBuilder,
    required this.inputTextFocusNode,
    required this.chatController,
    required this.roomId,
    required this.onTapBg,
    this.onLoad,
    this.onRefresh,
    this.refreshHeader,
    this.refreshFooter,
    this.customPinBuilder,
    this.customHeadBuilder,
    this.customBottomBuilder,
    this.customListHeadBuilder,
    this.customJumpBottomFloatBuilder,
    this.unreadCountFloatBuilder,
    this.popupMenuParams,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.showLoading = false,
    this.loadingView,
    this.cacheExtent,
    this.scrollListener,
    this.floatTipOffset,
    this.msgListOverlay,
    this.lastViewedTipView,
    super.key,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget>
    with AutomaticKeepAliveClientMixin {
  late ChatController chatController;

  final LayerLink layerLink = LayerLink();

  BuildContext? pageOverlayContext;

  int get roomId => widget.roomId;

  /// 顶部间距，loading时，把header部分留出来，可以进行退出页面或其他操作
  double? topMargin;

  /// 消息列表是否已完成初始化拉取，防止列表为空时，一直显示loading动画
  bool showLoading = false;

  /// 下拉加载消息时，为了列表不跳到底部，需要给一个较大的cacheExtent
  final ValueNotifier<double> _cacheExtent = ValueNotifier<double>(1000);

  double? scrollExtent;

  List<BuildContext> sliverListContexts = [];

  /// 如果列表头不为空，则增加一个构建项
  int get _listItemCount {
    int hc = widget.customListHeadBuilder == null ? 0 : 1;
    return chatController.showedMessageList.length + hc;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    showLoading = widget.showLoading;
    chatController = widget.chatController;
    chatController.init(ctx: context, update: update);
    chatController.scrollController.addListener(scrollControllerListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {
        chatController.checkIfNeedShowJumpToBottom();
        if (scrollExtent == null || scrollExtent! <= SizeConfig.screenHeight) {
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
    return widget.customJumpBottomFloatBuilder?.call(context) ??
        Icon(
          Icons.arrow_drop_down_circle_outlined,
          size: 40.w,
          color: Styles.white,
        );
  }

  Widget _buildUnreadTipView(BuildContext context, int value) {
    return widget.unreadCountFloatBuilder?.call(context, value) ??
        Text('消息未读$value');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // 保证输入框和安全区域的背景颜色一致
      backgroundColor: Styles.navigationBarColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: SafeArea(
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
        widget.customHeadBuilder?.call(context) ?? const SizedBox(),
        widget.customPinBuilder?.call(context) ?? const SizedBox(),
        Expanded(
            child: Stack(
          children: [
            _buildListView(),
            if (widget.msgListOverlay != null) widget.msgListOverlay!,
            _buildLoadingView(),
          ],
        )),
        CompositedTransformTarget(
          link: layerLink,
          child: Container(),
        ),
        widget.customBottomBuilder?.call(context) ?? const SizedBox(),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Positioned(
      top: 0,
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
    );
  }

  Widget _buildListView() {
    return Container(
      color: widget.backgroundColor,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Listener(
            // 监听手势滚动列表
            onPointerMove: (_) {
              widget.onTapBg();
            },
            // 监听手势点击屏幕
            onPointerDown: (_) {
              widget.onTapBg();
            },
            child: ListViewObserver(
              controller: chatController.observerController,
              onObserve: (ListViewObserveModel model) {
                chatController.updateDisplayingChildIndexList(
                    model.displayingChildIndexList);
              },
              sliverListContexts: () {
                return sliverListContexts;
              },
              child: EasyRefresh.builder(
                controller: chatController.easyRefreshController,
                footer: widget.refreshHeader ?? const MaterialFooter(),
                header: widget.refreshFooter ?? const MaterialHeader(),
                onLoad: widget.onLoad == null ? null : _onLoad,
                onRefresh: widget.onRefresh == null ? null : _onRefresh,
                childBuilder: (context, physics) {
                  var scrollViewPhysics =
                      physics.applyTo(ChatObserverClampingScrollPhysics(
                    observer: chatController.chatObserver,
                  ));
                  return ValueListenableBuilder<double?>(
                    valueListenable: _cacheExtent,
                    builder: (context, value, child) {
                      Widget resultWidget = ListView.builder(
                        padding: EdgeInsets.only(
                          top: 15.w,
                          bottom: 15.w,
                        ),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: chatController.chatObserver.isShrinkWrap
                            ? const NeverScrollableScrollPhysics()
                            : scrollViewPhysics,
                        reverse: true,
                        shrinkWrap: chatController.chatObserver.isShrinkWrap,
                        controller: chatController.scrollController,
                        cacheExtent: widget.cacheExtent ?? value,
                        itemCount: _listItemCount,
                        itemBuilder: ((context, index) {
                          if (index == 0) {
                            sliverListContexts.clear();
                          }
                          sliverListContexts.add(context);
                          if (widget.customListHeadBuilder != null &&
                              index ==
                                  chatController.showedMessageList.length) {
                            return widget.customListHeadBuilder?.call(context);
                          }
                          MessageCellModel cellModel =
                              chatController.showedMessageList[index];
                          if (widget.popupMenuParams == null) {
                            return widget.customMessageCellBuilder
                                .call(context, cellModel, index);
                          } else {
                            return PopupMenu(
                              menuBgColor: widget.popupMenuParams!.menuBgColor,
                              menuWidth: widget.popupMenuParams!.menuWidth,
                              menuHeight: widget.popupMenuParams!.menuHeight,
                              bottomMargin:
                                  widget.popupMenuParams!.bottomHeight,
                              pressType: widget.popupMenuParams!.pressType,
                              actions: widget.popupMenuParams!.getActions
                                  .call(cellModel),
                              buildAction: (type, removePop) => widget
                                  .popupMenuParams!
                                  .buildAction(type, cellModel, removePop),
                              onMenuShow: () {
                                widget.popupMenuParams!.onMenuShow
                                    ?.call(cellModel);
                              },
                              child: widget.customMessageCellBuilder
                                  .call(context, cellModel, index),
                            );
                          }
                        }),
                      );
                      if (chatController.chatObserver.isShrinkWrap) {
                        resultWidget = SingleChildScrollView(
                          reverse: true,
                          physics: scrollViewPhysics,
                          child: Container(
                            alignment: Alignment.topCenter,
                            height: constraints.maxHeight + 0.001,
                            child: resultWidget,
                          ),
                        );
                      }
                      return resultWidget;
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
