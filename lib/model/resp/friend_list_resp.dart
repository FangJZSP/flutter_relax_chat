import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/user_model.dart';

import 'apply_resp.dart';

part 'friend_list_resp.g.dart';

@JsonSerializable()
class FriendListResp {
  @JsonKey(defaultValue: [])
  final List<FriendModel> list;

  FriendListResp(
    this.list,
  );

  factory FriendListResp.fromJson(Map<String, dynamic> json) =>
      _$FriendListRespFromJson(json);

  Map<String, dynamic> toJson() => _$FriendListRespToJson(this);
}

@JsonSerializable()
class FriendModel {
  @JsonKey(defaultValue: 0)
  final int friendId;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String avatar;
  @JsonKey(defaultValue: 0)
  final int createTime;
  @JsonKey(defaultValue: '')
  final String message;
  @JsonKey(defaultValue: 0)
  final int status;

  FriendModel(
    this.friendId,
    this.name,
    this.avatar,
    this.createTime,
    this.message,
    this.status,
  );

  ApplyStatus get applyStatus =>
      ApplyStatus.fromCode(status) ?? ApplyStatus.unreadPending;

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendModelToJson(this);

  UserModel get wrapAsUser => UserModel.fromJson({})
    ..uid = friendId
    ..name = name
    ..avatar = avatar;
}
