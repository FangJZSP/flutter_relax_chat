import 'package:json_annotation/json_annotation.dart';

part 'text_msg_req.g.dart';

@JsonSerializable()
class TextMsgReq {
  @JsonKey(defaultValue: '')
  String content;

  int? replyMsgId;

  @JsonKey(defaultValue: [])
  List<int> atUidList;

  TextMsgReq(
    this.content,
    this.replyMsgId,
    this.atUidList,
  );

  factory TextMsgReq.fromJson(Map<String, dynamic> json) =>
      _$TextMsgReqFromJson(json);

  Map<String, dynamic> toJson() => _$TextMsgReqToJson(this);
}
