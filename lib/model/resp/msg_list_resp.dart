import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';

part 'msg_list_resp.g.dart';

@JsonSerializable()
class MessageListResp {
  @JsonKey(defaultValue: '')
  String cursor;
  @JsonKey(defaultValue: false)
  bool isLast;
  @JsonKey(defaultValue: [])
  List<WSMessageModel> list;

  MessageListResp(
    this.cursor,
    this.isLast,
    this.list,
  );

  factory MessageListResp.fromJson(Map<String, dynamic> json) =>
      _$MessageListRespFromJson(json);

  Map<String, dynamic> toJson() => _$MessageListRespToJson(this);
}

MessageListResp defaultMessageListResp(var value) {
  if (value == null) {
    return MessageListResp.fromJson({});
  }
  return MessageListResp.fromJson(value);
}
