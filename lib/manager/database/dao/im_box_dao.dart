import 'package:get/get.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';

import '../../user_manager.dart';
import '../../../model/conversation_model.dart';
import '../../event_bus_manager.dart';
import '../../log_manager.dart';
import '../base/base_box.dart';
import '../base/base_dao.dart';

class ImBoxDao implements BaseDao {
  static ImBoxDao get instance => _instance ??= ImBoxDao._();
  static ImBoxDao? _instance;

  ImBoxDao._();

  /// 消息盒子
  BaseBox<WSMessageModel>? messageBox;

  /// 会话盒子
  BaseBox<ConversationModel>? conversationBox;

  /// 未读消息总数
  final RxInt unreadMessageCount = 0.obs;

  /// 未读会话总数
  final RxInt unreadRoomCount = 0.obs;

  /// 未读会话列表
  final RxList<ConversationModel> unreadRoomList = RxList.empty();

  /// 会话列表
  final List<ConversationModel> _conversations = [];

  /// 己方发出的消息，需要展示接收状态和已读状态，但服务器数据有一段时间的延迟，
  /// 可能有些消息对方已读了，但服务器会返回该消息未送达。为了更准确的显示消息状态，
  /// 客户端对发送成功的消息做短时间的记录，展示消息时，优先使用本地记录的msg内容，其次再使用远端数据
  /// 只需要记录本次启动产生的成功发送的消息，具体记录逻辑查看本字段的赋值代码即可
  final Map<String, WSMessageModel> _succeedSentMsg = {};

  /// 当前用户uid
  int myUid = 0;

  /// 本地缓存读取会话列表
  /// 远端更新时，及时刷新本地会话列表
  List<ConversationModel> get conversations {
    List<ConversationModel> list = [];
    for (var element in _conversations) {
      var cacheModel = conversationBox?.get(element.roomId.toString());
      if (cacheModel != null) {
        list.add(cacheModel);
      }
    }
    return list;
  }

  /// 处理远端拉取到的会话列表
  Future<void> handleRemoteConversations() async {
    logger.d('处理');
  }

  Future<void> deleteConversation(ConversationModel room) async {
    _conversations.removeWhere((element) => element.roomId == room.roomId);
    await conversationBox?.delete(room.roomId.toString());
    _updateUnreadMessageCount();
    _updateUnreadConversationCount();
    eventBus.fire(UpdateConversationListEvent());
  }

  /// 保存会话 并根据最后一条消息更新会话顺序
  Future saveConversation(ConversationModel room) async {
    await conversationBox?.set(room.roomId.toString(), room);
    _conversations.add(room);
    // todo 根据会话的最后一条消息的时间更新会话顺序
    _updateUnreadMessageCount();
    _updateUnreadConversationCount();
    eventBus.fire(UpdateConversationListEvent());
  }

  void setConversationRead(int roomId) {
    List<WSMessageModel>? receivedMessages = messageBox?.getList(
        where: (e) => e.msg.roomId == roomId && !e.senderIsMe);
    receivedMessages?.forEach((element) {
      messageBox?.delete(element.msg.roomId.toString());
    });
    var room = getConversation(roomId);
    if (room != null) {
      // room.didRead = true;
      // room.lastMessage?.chatMarker = ChatMarkerType.displayed.code;
      conversationBox?.set(roomId.toString(), room);
      _updateUnreadMessageCount();
      _updateUnreadConversationCount();
      eventBus.fire(UpdateConversationListEvent());
    }
  }

  ConversationModel? getConversation(int roomId) {
    var cacheConversation =
        _conversations.firstWhereOrNull((e) => e.roomId == roomId);
    return cacheConversation ?? conversationBox?.get(roomId.toString());
  }

  WSMessageModel? getMessage(String messageId) {
    var cacheModel = messageBox?.get(messageId);
    if (cacheModel != null) {
      return cacheModel;
    }
    WSMessageModel? succeedCacheModel = _succeedSentMsg[messageId];
    return succeedCacheModel;
  }

  Future<void> saveMessage(WSMessageModel message) async {}

  List<WSMessageModel> getNotSuccessMessage(String conversationId) {
    return [];
  }

  Future<void> _updateUnreadMessageCount() async {
    int unreadCount = 0;
    // ws 未连接时
    var cacheMessages =
        messageBox?.getList(where: (e) => e.msg.senderId != myUid);
    cacheMessages?.forEach((element) {
      // 设置消息已读
    });
    unreadMessageCount.value = unreadCount;
  }

  Future<void> _updateUnreadConversationCount() async {}

  @override
  Future<void> init() async {
    myUid = UserManager.instance.state.user.value.uid;
    messageBox = BaseBox<WSMessageModel>(
      '${UserManager.instance.state.user.value.uid}_messageBox',
      WSMessageModel.fromJson,
      (model) => model.toJson(),
    );
    await messageBox?.initBox();

    conversationBox = BaseBox<ConversationModel>(
      '${UserManager.instance.state.user.value.uid}_conversationBox',
      ConversationModel.fromJson,
      (model) => model.toJson(),
    );
    await conversationBox?.initBox();
    _updateUnreadMessageCount();
    _updateUnreadConversationCount();
  }

  @override
  Future<void> close() async {
    myUid = 0;
    unreadMessageCount.value = 0;
    _conversations.clear();
    _succeedSentMsg.clear();
    await messageBox?.closeBox();
    await conversationBox?.closeBox();
  }
}
