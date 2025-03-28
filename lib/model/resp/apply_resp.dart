import 'package:json_annotation/json_annotation.dart';

part 'apply_resp.g.dart';

@JsonSerializable()
class ApplyResp {
  @JsonKey(defaultValue: false)
  bool success;

  ApplyResp(
    this.success,
  );

  factory ApplyResp.fromJson(Map<String, dynamic> json) =>
      _$ApplyRespFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyRespToJson(this);
}

ApplyResp defaultApplyResp(var value) {
  if (value == null) {
    return ApplyResp.fromJson({});
  }
  return ApplyResp.fromJson(value);
}
