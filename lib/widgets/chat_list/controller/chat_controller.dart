import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/widget/message_cell_model.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

/// 聊天控制器
/// UI展示 [T extends MessageCellModel]
class ChatController<T extends MessageCellModel> {
  ChatController({
    required this.inputFocusNode,
    required this.jumpToBottomCallback,
    this.needJumpToBottomWhenSendNewMsg = true,
  }) {
    // 列表观察
    observerController = ListObserverController(controller: scrollController)
      ..cacheJumpIndexOffset = false;

    // 聊天滚动观察
    chatObserver = ChatScrollObserver(observerController)
      ..fixedPositionOffset = 5
      ..onHandlePositionResultCallback = (result) {
        if (!needIncrementUnreadMsgCount) {
          return;
        }
        switch (result.type) {
          case ChatScrollObserverHandlePositionType.keepPosition:
            updateUnreadMsgCount(changeCount: result.changeCount);
            break;
          case ChatScrollObserverHandlePositionType.none:
            updateUnreadMsgCount(isReset: true);
            break;
        }
      };
  }

  ScrollController scrollController = ScrollController();

  late ListObserverController observerController;

  late ChatScrollObserver chatObserver;

  final FocusNode inputFocusNode;

  Function()? updateState;

  final Function() jumpToBottomCallback;

  final bool needJumpToBottomWhenSendNewMsg;

  int initTime = DateTime.now().millisecondsSinceEpoch;

  EasyRefreshController easyRefreshController = EasyRefreshController();

  BuildContext? context;

  RxInt unreadMsgCount = 0.obs;

  RxnInt lastViewedMessageId = RxnInt();

  RxBool showJumpToBottom = false.obs;

  /// 是否已读最后看到的消息
  RxBool hasReadLastViewedMessage = false.obs;

  /// 是否需要增加未读消息数量
  bool needIncrementUnreadMsgCount = false;

  /// 是否输入中
  RxBool isComposing = false.obs;

  /// 正在展示子组件索引列表
  List<int> displayingChildIndexList = [];

  /// 第一条未读的消息
  Rxn<T> firstUnreadMessage = Rxn<T>();

  List<T> messageList = [];

  /// 有置顶或引用消息，点击时要跳转到对应位置时，
  /// 但是该消息可能不在当前 [messageList] 里面，需要额外加载对应页码的消息数据，
  /// 此时拉取的消息列表存到 [cachedMessageList] 里面
  /// 另外，此时还可以上拉下拉加载消息，当消息没有到达 [messageList] 的位置时，
  /// 拉取的新消息也需要存到 [cachedMessageList] 内，
  /// 直到 [messageList] 和 [cachedMessageList] 有重叠消息，
  /// 或者刚好 [cachedMessageList] 的第一条消息为 [messageList] 的下一条时，
  /// 合并 [cachedMessageList] 到 [messageList]，并清空 [cachedMessageList]
  List<T> cachedMessageList = [];

  List<T> get showedMessageList =>
      cachedMessageList.isNotEmpty ? cachedMessageList : messageList;

  bool get bottomNear =>
      displayingChildIndexList.isNotEmpty &&
      displayingChildIndexList.first <= 3;

  bool get hasReadAll => unreadMsgCount.value <= 0;

  void init({required BuildContext ctx, VoidCallback? update}) {
    updateState = update;
    context = ctx;
    chatObserver.toRebuildScrollViewCallback = updateState;
  }

  void dispose() {
    scrollController.dispose();
    easyRefreshController.dispose();
  }

  /// 更新处理单个或多个消息
  void updateMessage(dynamic data) {
    assert(data is T || data is List<T>, '更新消息必须是 T 或者 List<T>');
    if (data is T) {
      /// 处理单个消息
      T bean = data;
      List<T> list = [];
      if (bean.cachedMsg) {
        list = cachedMessageList;
      } else {
        list = messageList;
      }
      handleMessageNeedStandBy(bean, list);
    } else if (data is List<T>) {
      /// 处理多个消息
      int standByCount = 0;
      bool firstUpdate = false;
      for (T bean in data) {
        List<T> list = [];
        if (bean.cachedMsg) {
          list = cachedMessageList;
        } else {
          list = messageList;
        }
        if (list.isEmpty) {
          firstUpdate = true;
        }
        bool needStandBy =
            handleMessageNeedStandBy(bean, list, needStandBy: false);
        standByCount += needStandBy ? 1 : 0;
      }
      if (firstUpdate) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          standby(standByCount);
        });
      } else {
        standby(standByCount);
      }
    }
    updateState?.call();
  }

  /// 调整列表位置
  void standby(int standByCount) {
    if (!inputFocusNode.hasFocus) {
      chatObserver.standby(changeCount: standByCount);
    }
  }

  /// 处理消息并决定是否需要调整列表位置
  bool handleMessageNeedStandBy(
    T bean,
    List<T> list, {
    bool needStandBy = true,
  }) {
    switch (bean.msgCellType) {
      /// 插入消息
      case MessageCellType.insert:
        {
          if (bean.insertIndex != null) {
            messageList.insert(bean.insertIndex!, bean);
            if (needStandBy) {
              standby(1);
            }
          }
          break;
        }

      /// 标记消息已读
      case MessageCellType.chatMarker:
        {
          for (T model in list) {
            if (model.messageModel.msg.id == bean.messageModel.msg.id) {
              if (bean.chatMarker != null) {
                model.chatMarker = bean.chatMarker;
              }
            }
          }
          break;
        }

      /// 输入中消息
      case MessageCellType.composing:
        {
          break;
        }

      /// 更新消息
      case MessageCellType.update:
        {
          for (T model in list) {
            // 远端拉取的消息有msgId，但messageId为''
            // 本地发送的消息有messageId(为自己创建的标识)，但msgId为0
            if (model.messageModel.msg.id == bean.messageModel.msg.id &&
                model.messageId == bean.messageId) {
              model.updateMessage(bean.messageModel);
            }
          }
          break;
        }

      /// 添加新消息
      case MessageCellType.addNew:
        {
          if (!bean.messageModel.senderIsMe && !bean.cachedMsg) {
            needIncrementUnreadMsgCount = true;
          }
          if (needStandBy && cachedMessageList.isEmpty) {
            standby(1);
          }
          list.insert(0, bean);
          if (bean.messageModel.senderIsMe &&
              !bean.cachedMsg &&
              needJumpToBottomWhenSendNewMsg &&
              scrollController.hasClients) {
            scrollToBottom();
          }
          handleComposing();
          return true;
        }

      /// 添加旧消息
      case MessageCellType.addOld:
        {
          needIncrementUnreadMsgCount = false;
          list.insert(list.length, bean);
          handleComposing();
          break;
        }
    }
    return false;
  }

  void mergeMessages() {
    for (T cachedMsg in cachedMessageList) {
      if (messageList.indexWhere((element) =>
              element.messageModel.msg.id == cachedMsg.messageModel.msg.id) ==
          -1) {
        messageList.add(cachedMsg);
      }
    }
    cachedMessageList.clear();
    updateState?.call();
  }

  void handleComposing() {
    // 增加输入中状态
  }

  /// 处理撤回消息
  void handleRetract(T bean) {
    messageList.removeWhere(
        (element) => element.messageModel.msg.id == bean.messageModel.msg.id);
  }

  void updateUnreadMsgCount({bool isReset = false, int changeCount = 1}) {
    needIncrementUnreadMsgCount = false;
    if (isReset) {
      unreadMsgCount.value = 0;
    } else {
      unreadMsgCount.value += changeCount;
    }
    if (unreadMsgCount.value > 0) {
      firstUnreadMessage.value = showedMessageList[unreadMsgCount.value - 1];
    }
  }

  Future<int?> scrollToMessage(T? cell) async {
    if (cell == null) {
      return null;
    }
    int index = showedMessageList.indexWhere(
        (element) => element.messageModel.msg.id == cell.messageModel.msg.id);
    if (index != -1) {
      await observerController.jumpTo(
        index: index,
      );
      return showedMessageList[index].messageModel.msg.id;
    }
    return null;
  }

  Future<void> scrollToIndex(int index) async {
    await observerController.jumpTo(
      index: index,
    );
  }

  Future<void> scrollToTop() async {
    if (observerController.controller != null) {
      await Future.delayed(const Duration(milliseconds: 50));
      await observerController.controller?.animateTo(
          observerController.controller?.position.maxScrollExtent ?? 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear);
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    updateUnreadMsgCount(isReset: true);
    cachedMessageList.clear();
    jumpToBottomCallback.call();
    checkIfNeedShowJumpToBottom();
  }

  void scrollToFirstUnreadMessage() {
    if (firstUnreadMessage.value != null) {
      scrollToMessage(firstUnreadMessage.value).then((value) {
        if (value != null) {
          unreadMsgCount.value = 0;
        }
      });
    } else {
      scrollToBottom();
    }
    if (displayingChildIndexList.isNotEmpty) {
      updateLastViewedMessageId(
          showedMessageList[displayingChildIndexList.last].messageModel.msg.id);
    }
  }

  void updateLastViewedMessageId(int messageId) {
    if (messageId > 0) {
      lastViewedMessageId.value = messageId;
      hasReadLastViewedMessage.value = false;
    }
  }

  void updateDisplayingChildIndexList(List<int> list) {
    displayingChildIndexList = list;
    int? index = messageIndex(lastViewedMessageId.value);
    if (index != null && displayingChildIndexList.contains(index)) {
      hasReadLastViewedMessage.value = true;
    }
  }

  int? messageIndex(int? messageId) {
    if (messageId == null) {
      return null;
    }
    int index = showedMessageList
        .indexWhere((element) => element.messageModel.msg.id == messageId);
    return index >= 0 ? index : null;
  }

  void scrollToLastViewedMessage() {
    if (lastViewedMessageId.value != null && !hasReadLastViewedMessage.value) {
      T? model = showedMessageList.firstWhereOrNull((element) =>
          element.messageModel.msg.id == lastViewedMessageId.value);
      scrollToMessage(model).then((value) {
        if (value != null) {
          hasReadLastViewedMessage.value = true;
        }
      });
    }
  }

  void removeMessage({bool Function(T)? where, int? index}) {
    if (index != null) {
      showedMessageList.removeAt(index);
    } else if (where != null) {
      showedMessageList.removeWhere(where);
    }
    updateState?.call();
  }

  void checkIfNeedShowJumpToBottom() {
    if (scrollController.offset >
            (chatObserver.observerController.viewportHeight ?? 100) ||
        cachedMessageList.isNotEmpty) {
      if (!showJumpToBottom.value) {
        showJumpToBottom.value = true;
      }
    } else {
      if (showJumpToBottom.value) {
        showJumpToBottom.value = false;
      }
    }
  }
}

extension ListObserverControllerExtension on ListObserverController {
  double? get viewportHeight {
    final ctx = fetchSliverContext();
    if (ctx == null) {
      return null;
    }
    final obj = ObserverUtils.findRenderObject(ctx);
    if (obj is! RenderSliver) {
      return null;
    }
    final viewportMainAxisExtent = obj.constraints.viewportMainAxisExtent;
    return viewportMainAxisExtent;
  }

  double? get scrollExtent {
    final ctx = fetchSliverContext();
    if (ctx == null) {
      return null;
    }
    final obj = ObserverUtils.findRenderObject(ctx);
    if (obj is! RenderSliver) {
      return null;
    }
    final scrollExtent = obj.geometry?.scrollExtent ?? 0;
    return scrollExtent;
  }
}
