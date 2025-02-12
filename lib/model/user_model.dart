import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  // 数据库主键 实际为user表的id
  @JsonKey(defaultValue: 0)
  int uid;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String avatar;
  @JsonKey(defaultValue: 0)
  int sex;
  @JsonKey(defaultValue: 0)
  int modifyNameChance;

  UserModel(
    this.uid,
    this.name,
    this.avatar,
    this.sex,
    this.modifyNameChance,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

UserModel defaultUserModel(var value) {
  if (value == null) {
    return UserModel.fromJson({});
  }
  return UserModel.fromJson(value);
}
