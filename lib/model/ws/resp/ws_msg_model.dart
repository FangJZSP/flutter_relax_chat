import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/user_model.dart';

import '../../../manager/user_manager.dart';
import '../../msg_model.dart';

part 'ws_msg_model.g.dart';

enum WSRespTypeEnum {
  loginUrl(1, '登录二维码返回'),
  loginScanSuccess(2, '用户扫描成功等待授权'),
  loginSuccess(3, '用户登录成功运回用户信息'),
  newMessage(4, '新消息'),
  onlineOfflineNotify(5, '上下线通知'),
  invalidToken(6, '使客户端的token失效，意味着客户端需要重新登录'),
  black(7, '拉黑用户'),
  mark(8, '消息标记'),
  recall(9, '消息撒回'),
  apply(10, '好友申请'),
  memberChange(11, '成员变动'),
  loginEmail(12, '邮箱登录返回'),
  ;

  final int type;
  final String desc;

  const WSRespTypeEnum(this.type, this.desc);

  static WSRespTypeEnum? fromType(int type) {
    for (var respType in WSRespTypeEnum.values) {
      if (respType.type == type) {
        return respType;
      }
    }
    return null;
  }
}

@JsonSerializable()
class WSBaseResponseModel {
  @JsonKey(defaultValue: -1)
  int type;

  dynamic res;

  WSBaseResponseModel(
    this.type,
    this.res,
  );

  factory WSBaseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WSBaseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSBaseResponseModelToJson(this);
}

@JsonSerializable()
class WSLoginSuccessModel {
  @JsonKey(defaultValue: -1)
  int uid;

  @JsonKey(defaultValue: '')
  String token;

  WSLoginSuccessModel(
    this.uid,
    this.token,
  );

  factory WSLoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$WSLoginSuccessModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSLoginSuccessModelToJson(this);
}

@JsonSerializable()
class WSFriendApplyModel {
  @JsonKey(defaultValue: -1)
  int uid;

  @JsonKey(defaultValue: 0)
  int unreadCount;

  WSFriendApplyModel(
    this.uid,
    this.unreadCount,
  );

  factory WSFriendApplyModel.fromJson(Map<String, dynamic> json) =>
      _$WSFriendApplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSFriendApplyModelToJson(this);
}

@JsonSerializable()
class WSBlackModel {
  @JsonKey(defaultValue: -1)
  int uid;

  WSBlackModel(
    this.uid,
  );

  factory WSBlackModel.fromJson(Map<String, dynamic> json) =>
      _$WSBlackModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSBlackModelToJson(this);
}

@JsonSerializable()
class WSMessageModel {
  // @JsonKey(defaultValue: [])
  // List<int> uidList;

  @JsonKey(fromJson: defaultMessageModel)
  MessageModel msg;

  WSMessageModel(this.msg);

  factory WSMessageModel.fromJson(Map<String, dynamic> json) =>
      _$WSMessageModelFromJson(json);

  bool get senderIsMe {
    return msg.senderId == UserManager.instance.state.user.value.uid;
  }

  Map<String, dynamic> toJson() => _$WSMessageModelToJson(this);
}

WSMessageModel defaultWSMessageModel(var value) {
  if (value == null) {
    return WSMessageModel.fromJson({});
  }
  return WSMessageModel.fromJson(value);
}
