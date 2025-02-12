import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/conversation_model.dart';

part 'conversation_list_resp.g.dart';

@JsonSerializable()
class ConversationListResp {
  @JsonKey(defaultValue: '')
  String cursor;
  @JsonKey(defaultValue: false)
  bool isLast;
  @JsonKey(defaultValue: [])
  List<ConversationModel> list;

  ConversationListResp(
    this.cursor,
    this.isLast,
    this.list,
  );

  factory ConversationListResp.fromJson(Map<String, dynamic> json) =>
      _$ConversationListRespFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationListRespToJson(this);
}

ConversationListResp defaultConversationListResp(var value) {
  if (value == null) {
    return ConversationListResp.fromJson({});
  }
  return ConversationListResp.fromJson(value);
}
