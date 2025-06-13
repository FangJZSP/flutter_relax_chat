import 'package:json_annotation/json_annotation.dart';

part 'apply_resp.g.dart';

enum ApplyStatus {
  unreadPending(1, '未读待审批'),
  readPending(2, '已读待审批'),
  accepted(3, '已同意'),
  rejected(4, '已拒绝');

  final int code;
  final String desc;

  const ApplyStatus(this.code, this.desc);

  static ApplyStatus? fromCode(int code) {
    return ApplyStatus.values.firstWhere(
      (element) => element.code == code,
      orElse: () => ApplyStatus.unreadPending,
    );
  }
}

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
