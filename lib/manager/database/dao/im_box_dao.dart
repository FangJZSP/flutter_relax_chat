import 'package:get/get.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';

import '../../user_manager.dart';
import '../../../model/conversation_model.dart';
import '../../event_bus_manager.dart';
import '../../log_manager.dart';
import '../base/base_box.dart';
import '../base/base_dao.dart';

class ImBoxDao extends BaseDao {
  static ImBoxDao get instance => _instance ??= ImBoxDao._();
  static ImBoxDao? _instance;

  ImBoxDao._();

  /// 消息盒子
  BaseBox<WSMessageModel>? messageBox;

  /// 会话盒子
  BaseBox<ConversationModel>? roomBox;

  /// 未读消息总数
  final RxInt unreadMessageCount = 0.obs;

  /// 未读会话总数
  final RxInt unreadRoomCount = 0.obs;

  /// 未读会话列表
  final RxList<ConversationModel> unreadRoomList = RxList.empty();

  /// 会话列表
  final List<ConversationModel> _rooms = [];

  /// 己方发出的消息，需要展示接收状态和已读状态，但服务器数据有一段时间的延迟，
  /// 可能有些消息对方已读了，但服务器会返回该消息未送达。为了更准确的显示消息状态，
  /// 客户端对发送成功的消息做短时间的记录，展示消息时，优先使用本地记录的msg内容，其次再使用远端数据
  /// 只需要记录本次启动产生的成功发送的消息，具体记录逻辑查看本字段的赋值代码即可
  final Map<String, WSMessageModel> _succeedSentMsg = {};

  /// 当前用户uid
  int _myUid = 0;

  /// 本地缓存读取会话列表
  /// 远端更新时，及时刷新本地会话列表
  List<ConversationModel> get rooms {
    List<ConversationModel> list = [];
    for (var element in _rooms) {
      var cacheModel = roomBox?.get(element.roomId.toString());
      if (cacheModel != null) {
        list.add(cacheModel);
      }
    }
    return list;
  }

  /// 处理远端拉取到的会话列表
  Future<void> handleRemoteRooms() async {
    logger.d('处理');
  }

  Future<void> deleteConversation(ConversationModel room) async {
    _rooms.removeWhere((element) => element.roomId == room.roomId);
    await roomBox?.delete(room.roomId.toString());
    _updateUnreadMessageCount();
    _updateUnreadRoomCount();
    eventBus.fire(UpdateRoomListEvent());
  }

  /// 保存会话 并根据最后一条消息更新会话顺序
  Future saveConversation(ConversationModel room) async {
    await roomBox?.set(room.roomId.toString(), room);
    _rooms.add(room);
    // todo 根据会话的最后一条消息的时间更新会话顺序
    _updateUnreadMessageCount();
    _updateUnreadRoomCount();
    eventBus.fire(UpdateRoomListEvent());
  }

  void setRoomRead(int roomId) {
    List<WSMessageModel>? receivedMessages = messageBox?.getList(
        where: (e) => e.msg.roomId == roomId && !e.senderIsMe);
    receivedMessages?.forEach((element) {
      messageBox?.delete(element.msg.roomId.toString());
    });
    var room = getRoom(roomId);
    if (room != null) {
      // room.didRead = true;
      // room.lastMessage?.chatMarker = ChatMarkerType.displayed.code;
      roomBox?.set(roomId.toString(), room);
      _updateUnreadMessageCount();
      _updateUnreadRoomCount();
      eventBus.fire(UpdateRoomListEvent());
    }
  }

  ConversationModel? getRoom(int roomId) {
    var cacheConversation = _rooms.firstWhereOrNull((e) => e.roomId == roomId);
    return cacheConversation ?? roomBox?.get(roomId.toString());
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
        messageBox?.getList(where: (e) => e.msg.senderId != _myUid);
    cacheMessages?.forEach((element) {
      // 设置消息已读
    });
    unreadMessageCount.value = unreadCount;
  }

  Future<void> _updateUnreadRoomCount() async {}

  @override
  Future<void> init() async {
    _myUid = UserManager.instance.state.user.value.uid;
    messageBox = BaseBox<WSMessageModel>(
      '${UserManager.instance.state.user.value.uid}_messageBox',
      WSMessageModel.fromJson,
      (model) => model.toJson(),
    );
    await messageBox?.initBox();

    roomBox = BaseBox<ConversationModel>(
      '${UserManager.instance.state.user.value.uid}_roomBox',
      ConversationModel.fromJson,
      (model) => model.toJson(),
    );
    await roomBox?.initBox();
    _updateUnreadMessageCount();
    _updateUnreadRoomCount();
  }

  @override
  Future<void> close() async {
    _myUid = 0;
    unreadMessageCount.value = 0;
    _rooms.clear();
    _succeedSentMsg.clear();
    await messageBox?.closeBox();
    await roomBox?.closeBox();
  }
}
