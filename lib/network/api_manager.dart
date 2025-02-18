import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';
import 'package:relax_chat/network/result.dart';

import '../common/common.dart';
import '../manager/global_manager.dart';
import '../model/resp/msg_list_resp.dart';
import '../model/resp/conversation_list_resp.dart';
import '../model/resp/friend_list_resp.dart';
import '../model/user_model.dart';
import 'net_request.dart';

final api = ApiManager();

class ApiManager {
  static String get hostStr {
    return GlobalManager.instance.state.isDev
        ? Info.serveDevUrl
        : Info.serveProdUrl;
  }

  /// 用户注册
  Future<Result<String>> userRegister({
    required String name,
    required String email,
    required String code,
    required String password,
  }) async {
    Result<String> result = await net.postRequest(
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
  Future<Result<MessageListResp>> getMessageList(
      {required int roomId, String? cursor, int size = 20}) async {
    Result<MessageListResp> result = await net.postRequest(
      '$hostStr/chat/msg/list',
      {
        if (cursor != null) 'cursor': cursor,
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
  Future<Result<FriendListResp>> getFriendList({
    String? cursor,
    int page = 1,
    int size = 10,
  }) async {
    Result<FriendListResp> result = await net.postRequest(
      '$hostStr/friend/list',
      {
        'page': page,
        'size': size,
        if (cursor != null) 'cursor': cursor,
      },
      fromJson: FriendListResp.fromJson,
    );
    return result;
  }
}
