import 'package:json_annotation/json_annotation.dart';

part 'msg_reply_model.g.dart';

@JsonSerializable()
class MessageReplyModel {
  @JsonKey(defaultValue: 0)
  int id;
  @JsonKey(defaultValue: '')
  String username;
  @JsonKey(defaultValue: '')
  String content;
  @JsonKey(defaultValue: '')
  String body;
  @JsonKey(defaultValue: 0)
  int canCallback;
  @JsonKey(defaultValue: 0)
  int gapCount;

  MessageReplyModel(
    this.id,
    this.username,
    this.content,
    this.body,
    this.canCallback,
    this.gapCount,
  );

  factory MessageReplyModel.fromJson(Map<String, dynamic> json) =>
      _$MessageReplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageReplyModelToJson(this);
}

MessageReplyModel defaultMessageReplyModel(var value) {
  if (value == null) {
    return MessageReplyModel.fromJson({});
  }
  return MessageReplyModel.fromJson(value);
}
