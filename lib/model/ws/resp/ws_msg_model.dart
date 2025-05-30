import 'package:json_annotation/json_annotation.dart';
import '../../../manager/user_manager.dart';
import '../../msg_model.dart';

part 'ws_msg_model.g.dart';

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
