import 'package:json_annotation/json_annotation.dart';

import 'friend_list_resp.dart';

part 'friend_apply_list_resp.g.dart';

@JsonSerializable()
class FriendApplyListResp {
  @JsonKey(defaultValue: [])
  final List<FriendModel> list;
  @JsonKey(defaultValue: 20)
  final int size;
  @JsonKey(defaultValue: 1)
  final int page;
  @JsonKey(defaultValue: 0)
  final int total;

  FriendApplyListResp(
    this.list,
    this.size,
    this.page,
    this.total,
  );

  factory FriendApplyListResp.fromJson(Map<String, dynamic> json) =>
      _$FriendApplyListRespFromJson(json);

  Map<String, dynamic> toJson() => _$FriendApplyListRespToJson(this);
}
