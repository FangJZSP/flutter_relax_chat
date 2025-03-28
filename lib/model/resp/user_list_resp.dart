import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/user_model.dart';

part 'user_list_resp.g.dart';

@JsonSerializable()
class UserListResp {
  @JsonKey(defaultValue: [])
  final List<UserModel> list;

  UserListResp(
    this.list,
  );

  factory UserListResp.fromJson(Map<String, dynamic> json) =>
      _$UserListRespFromJson(json);

  Map<String, dynamic> toJson() => _$UserListRespToJson(this);
}
