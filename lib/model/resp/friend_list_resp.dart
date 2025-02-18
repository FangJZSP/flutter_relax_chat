import 'package:json_annotation/json_annotation.dart';

part 'friend_list_resp.g.dart';

@JsonSerializable()
class FriendListResp {
  @JsonKey(defaultValue: [])
  final List<FriendModel> list;
  @JsonKey(defaultValue: '')
  final String cursor;

  FriendListResp(
    this.list,
    this.cursor,
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

  FriendModel(
    this.friendId,
    this.name,
    this.avatar,
    this.createTime,
  );

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendModelToJson(this);
}
