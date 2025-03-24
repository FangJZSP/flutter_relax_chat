import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/room_model.dart';

part 'group_room_list_resp.g.dart';

@JsonSerializable()
class GroupRoomListResp {
  @JsonKey(defaultValue: [])
  final List<RoomModel> list;

  GroupRoomListResp(
    this.list,
  );

  factory GroupRoomListResp.fromJson(Map<String, dynamic> json) =>
      _$GroupRoomListRespFromJson(json);

  Map<String, dynamic> toJson() => _$GroupRoomListRespToJson(this);
}
