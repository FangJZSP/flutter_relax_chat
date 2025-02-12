import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/ws/req/ws_base_req.dart';

part 'ws_email_req.g.dart';

@JsonSerializable()
class WSEmailReq extends WSBaseReqModel {
  @JsonKey(fromJson: defaultEmailData)
  EmailData req;

  WSEmailReq(super.type, this.req);

  factory WSEmailReq.fromJson(Map<String, dynamic> json) =>
      _$WSEmailReqFromJson(json);

  Map<String, dynamic> toJson() => _$WSEmailReqToJson(this);
}

@JsonSerializable()
class EmailData {
  @JsonKey(defaultValue: '')
  String email;

  @JsonKey(defaultValue: false)
  bool needCode;

  EmailData(this.email, this.needCode);

  factory EmailData.fromJson(Map<String, dynamic> json) =>
      _$EmailDataFromJson(json);

  Map<String, dynamic> toJson() => _$EmailDataToJson(this);
}

EmailData defaultEmailData(var value) {
  if (value == null) {
    return EmailData.fromJson({});
  }
  return EmailData.fromJson(value);
}
