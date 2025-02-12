import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/ws/req/ws_base_req.dart';

part 'ws_token_req.g.dart';

@JsonSerializable()
class WSTokenReq extends WSBaseReqModel {
  @JsonKey(fromJson: defaultTokenData)
  TokenData req;

  WSTokenReq(super.type, this.req);

  factory WSTokenReq.fromJson(Map<String, dynamic> json) =>
      _$WSTokenReqFromJson(json);

  Map<String, dynamic> toJson() => _$WSTokenReqToJson(this);
}

@JsonSerializable()
class TokenData {
  @JsonKey(defaultValue: '')
  String token;

  TokenData(this.token);

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}

TokenData defaultTokenData(var value) {
  if (value == null) {
    return TokenData.fromJson({});
  }
  return TokenData.fromJson(value);
}
