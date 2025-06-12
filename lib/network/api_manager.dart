import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';
import 'package:relax_chat/network/result.dart';

import '../common/common.dart';
import '../manager/global_manager.dart';
import '../model/resp/apply_resp.dart';
import '../model/resp/friend_apply_list_resp.dart';
import '../model/resp/group_apply_list_resp.dart';
import '../model/resp/group_room_list_resp.dart';
import '../model/resp/msg_list_resp.dart';
import '../model/resp/conversation_list_resp.dart';
import '../model/resp/friend_list_resp.dart';
import '../model/resp/user_list_resp.dart';
import '../model/user_model.dart';
import 'net_request.dart';

final api = ApiManager();

class ApiManager {
  static String get hostStr {
    return GlobalManager.instance.isDev ? Info.serveDevUrl : Info.serveProdUrl;
  }

  /// 用户注册
  Future<Result> userRegister({
    required String name,
    required String email,
    required String code,
    required String password,
  }) async {
    Result result = await net.postRequest(
      '$hostStr/user/register',
      {
        'name': name,
        'email': email,
        'code': code,
        'password': password,
      },
    );
    return result;
  }

  /// 用户登录
  Future<Result> userLogin({
    required String email,
    required String password,
  }) async {
    Result result = await net.postRequest(
      '$hostStr/user/login',
      {
        'email': email,
        'password': password,
      },
    );
    return result;
  }

  /// 获取用户信息
  Future<Result<UserModel>> getUserInfo() async {
    Result<UserModel> result = await net.getRequest(
      '$hostStr/user/info',
      null,
      fromJson: UserModel.fromJson,
    );
    return result;
  }

  /// 获取会话列表
  Future<Result<ConversationListResp>> getConversationList(
      {String? cursor, int size = 10}) async {
    Result<ConversationListResp> result = await net.postRequest(
      '$hostStr/conversation/list',
      {
        if (cursor != null) 'cursor': cursor,
        'size': size,
      },
      fromJson: ConversationListResp.fromJson,
    );
    return result;
  }

  /// 获取消息列表
  Future<Result<MessageListResp>> getMessageList({
    required int roomId,
    required int page,
    String? cursor,
    int size = 20,
  }) async {
    Result<MessageListResp> result = await net.postRequest(
      '$hostStr/chat/msg/list',
      {
        if (cursor != null) 'cursor': cursor,
        'page': page,
        'size': size,
        'roomId': roomId,
      },
      fromJson: MessageListResp.fromJson,
    );
    return result;
  }

  /// 发送消息
  Future<Result<WSMessageModel>> sendMsg({
    required int roomId,
    required int msgType,
    required Object body,
  }) async {
    Result<WSMessageModel> result = await net.postRequest(
      '$hostStr/chat/msg',
      {
        'roomId': roomId.toString(),
        'msgType': msgType,
        'body': body,
      },
      fromJson: WSMessageModel.fromJson,
    );
    return result;
  }

  /// 获取邮箱验证码
  Future<Result<String>> sendEmailCode({
    required String email,
  }) async {
    Result<String> result = await net.getRequest(
      '$hostStr/email/sendCode',
      {
        'email': email,
      },
    );
    return result;
  }

  /// 验证邮箱验证码
  Future<Result<String>> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    Result<String> result = await net.getRequest(
      '$hostStr/email/verifyCode',
      {
        'email': email,
        'code': code,
      },
    );
    return result;
  }

  /// 获取好友列表
  Future<Result<FriendListResp>> getFriendList() async {
    Result<FriendListResp> result = await net.postRequest(
      '$hostStr/friend/list',
      null,
      fromJson: FriendListResp.fromJson,
    );
    return result;
  }

  /// 获取群了列表
  Future<Result<GroupRoomListResp>> getGroupRoomsList() async {
    Result<GroupRoomListResp> result = await net.postRequest(
      '$hostStr/room/group/list',
      null,
      fromJson: GroupRoomListResp.fromJson,
    );
    return result;
  }

  /// 搜索群聊列表
  Future<Result<GroupRoomListResp>> groupSearch({required String name}) async {
    Result<GroupRoomListResp> result = await net.postRequest(
      '$hostStr/group/search',
      {'name': name},
      fromJson: GroupRoomListResp.fromJson,
    );
    return result;
  }

  /// 搜索用户列表
  Future<Result<UserListResp>> friendSearch({required String name}) async {
    Result<UserListResp> result = await net.postRequest(
      '$hostStr/friend/search',
      {'name': name},
      fromJson: UserListResp.fromJson,
    );
    return result;
  }

  /// 申请好友
  Future<Result<ApplyResp>> applyFriend(
      {required String friendId, required String message}) async {
    Result<ApplyResp> result = await net.postRequest(
      '$hostStr/friend/apply',
      {'friendId': friendId, 'message': message},
      fromJson: ApplyResp.fromJson,
    );
    return result;
  }

  /// 申请群聊
  Future<Result<ApplyResp>> applyGroup(
      {required int roomId, required String message}) async {
    Result<ApplyResp> result = await net.postRequest(
      '$hostStr/group/apply',
      {'roomId': roomId, 'message': message},
      fromJson: ApplyResp.fromJson,
    );
    return result;
  }

  /// 获取好友申请列表
  Future<Result<FriendApplyListResp>> getFriendApplyList({
    int page = 1,
    int size = 20,
  }) async {
    Result<FriendApplyListResp> result = await net.postRequest(
      '$hostStr/friend/apply/list',
      {
        'page': page,
        'size': size,
      },
      fromJson: FriendApplyListResp.fromJson,
    );
    return result;
  }

  /// 审批好友申请
  Future<Result> approveFriend({
    required String friendId,
    required bool isApprove,
  }) async {
    Result result = await net.postRequest(
      '$hostStr/friend/approve',
      {
        'friendId': friendId,
        'isApprove': isApprove,
      },
    );
    return result;
  }

  /// 获取群申请列表
  Future<Result<GroupApplyListResp>> getGroupApplyList({
    int page = 1,
    int size = 20,
  }) async {
    Result<GroupApplyListResp> result = await net.postRequest(
      '$hostStr/group/apply/list',
      {
        'page': page,
        'size': size,
      },
      fromJson: GroupApplyListResp.fromJson,
    );
    return result;
  }
}
