import 'package:json_annotation/json_annotation.dart';

part 'msg_mark_model.g.dart';

@JsonSerializable()
class MessageMarkModel {
  @JsonKey(defaultValue: 0)
  int likeCount;
  @JsonKey(defaultValue: 0)
  int userLike;
  @JsonKey(defaultValue: 0)
  int dislikeCount;
  @JsonKey(defaultValue: 0)
  int userDislike;

  MessageMarkModel(
    this.likeCount,
    this.userLike,
    this.dislikeCount,
    this.userDislike,
  );

  factory MessageMarkModel.fromJson(Map<String, dynamic> json) =>
      _$MessageMarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageMarkModelToJson(this);
}

MessageMarkModel defaultMessageMarkModel(var value) {
  if (value == null) {
    return MessageMarkModel.fromJson({});
  }
  return MessageMarkModel.fromJson(value);
}
