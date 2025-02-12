import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel {
  @JsonKey(defaultValue: 0)
  int conversationId;
  @JsonKey(defaultValue: 0)
  int roomId;
  @JsonKey(defaultValue: '')
  String avatar;
  @JsonKey(defaultValue: 0)
  int type;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String text;
  @JsonKey(defaultValue: 0)
  int unreadCount;
  @JsonKey(defaultValue: 0)
  int activeTime;
  @JsonKey(defaultValue: 0)
  int readTime;
  @JsonKey(defaultValue: 0)
  int lastMsgId;

  ConversationModel(
    this.conversationId,
    this.roomId,
    this.activeTime,
    this.avatar,
    this.type,
    this.name,
    this.text,
    this.unreadCount,
    this.readTime,
    this.lastMsgId,
  );

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}

ConversationModel defaultConversationModel(var value) {
  if (value == null) {
    return ConversationModel.fromJson({});
  }
  return ConversationModel.fromJson(value);
}
