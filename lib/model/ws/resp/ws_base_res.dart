import 'package:json_annotation/json_annotation.dart';

part 'ws_base_res.g.dart';

enum WSResType {
  loginUrl(1, '登录二维码返回'),
  loginScanSuccess(2, '用户扫描成功等待授权'),
  loginSuccess(3, '用户登录成功并返回用户信息'),
  newMessage(4, '新消息'),
  onlineOfflineNotify(5, '上下线通知'),
  invalidToken(6, '使客户端的token失效，意味着客户端需要重新登录'),
  black(7, '拉黑用户'),
  mark(8, '消息标记'),
  recall(9, '消息撒回'),
  apply(10, '好友申请'),
  memberChange(11, '成员变动'),
  loginEmail(12, '邮箱登录返回'),
  heartBeat(13, '心跳检测'),
  connectSuccess(14, '心跳检测'),
  ;

  final int type;
  final String desc;

  const WSResType(this.type, this.desc);

  static WSResType? fromType(int type) {
    for (var respType in WSResType.values) {
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
