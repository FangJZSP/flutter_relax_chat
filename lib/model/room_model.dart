import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/conversation_model.dart';

part 'room_model.g.dart';

enum RoomType {
  single(2),
  group(1),
  ;

  final int type;

  const RoomType(this.type);
}

enum GroupRoomRole {
  owner(1),
  admin(2),
  member(3),
  ;

  final int type;

  const GroupRoomRole(this.type);
}

@JsonSerializable()
class RoomModel {
  @JsonKey(defaultValue: 0)
  int roomId;
  @JsonKey(defaultValue: 1)
  int type;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String avatar;
  @JsonKey(defaultValue: 3)
  int role;
  @JsonKey(defaultValue: 0)
  int createTime;

  RoomModel(
    this.roomId,
    this.type,
    this.name,
    this.avatar,
    this.role,
    this.createTime,
  );

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);

  ConversationModel get wrapAsConversation => ConversationModel.fromJson({})
    ..roomId = roomId
    ..name = name
    ..avatar = avatar
    ..type = type;
}

RoomModel defaultRoomModel(var value) {
  if (value == null) {
    return RoomModel.fromJson({});
  }
  return RoomModel.fromJson(value);
}
