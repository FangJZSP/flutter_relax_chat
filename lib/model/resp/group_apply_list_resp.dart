import 'package:json_annotation/json_annotation.dart';

part 'group_apply_list_resp.g.dart';

@JsonSerializable()
class GroupApplyListResp {
  @JsonKey(defaultValue: [])
  final List<GroupApplyModel> list;
  @JsonKey(defaultValue: 20)
  final int size;
  @JsonKey(defaultValue: 1)
  final int page;
  @JsonKey(defaultValue: 0)
  final int total;

  GroupApplyListResp(
    this.list,
    this.size,
    this.page,
    this.total,
  );

  factory GroupApplyListResp.fromJson(Map<String, dynamic> json) =>
      _$GroupApplyListRespFromJson(json);
}

@JsonSerializable()
class GroupApplyModel {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: 0)
  final int userId;
  @JsonKey(defaultValue: 0)
  final int roomId;
  @JsonKey(defaultValue: '')
  final String groupName;
  @JsonKey(defaultValue: '')
  final String groupAvatar;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String avatar;
  @JsonKey(defaultValue: '')
  final String message;
  @JsonKey(defaultValue: 0)
  final int status;
  @JsonKey(defaultValue: 0)
  final int createTime;

  GroupApplyModel(
    this.id,
    this.userId,
    this.roomId,
    this.groupName,
    this.groupAvatar,
    this.name,
    this.avatar,
    this.message,
    this.status,
    this.createTime,
  );

  factory GroupApplyModel.fromJson(Map<String, dynamic> json) =>
      _$GroupApplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupApplyModelToJson(this);
}
