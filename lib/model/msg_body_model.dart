import 'package:json_annotation/json_annotation.dart';
import 'msg_reply_model.dart';

part 'msg_body_model.g.dart';

@JsonSerializable()
class MessageBodyModel {
  @JsonKey(defaultValue: '')
  String content;

  @JsonKey(defaultValue: {})
  Map<String, dynamic> urlContentMap;

  @JsonKey(defaultValue: [])
  List<int> atUidList;

  @JsonKey(fromJson: defaultMessageReplyModel)
  MessageReplyModel reply;

  @JsonKey(defaultValue: '')
  String url;

  @JsonKey(defaultValue: 0)
  int width;

  @JsonKey(defaultValue: 0)
  int height;

  MessageBodyModel(
    this.content,
    this.urlContentMap,
    this.atUidList,
    this.reply,
    this.url,
    this.width,
    this.height,
  );

  factory MessageBodyModel.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageBodyModelToJson(this);
}

MessageBodyModel defaultMessageBodyModel(var value) {
  if (value == null) {
    return MessageBodyModel.fromJson({});
  }
  return MessageBodyModel.fromJson(value);
}
