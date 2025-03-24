import 'package:json_annotation/json_annotation.dart';

part 'contact_type_model.g.dart';

enum ContactType {
  friend(0, '好友'),
  groupChat(2, '群聊'),
  ;

  final int code;
  final String desc;

  const ContactType(this.code, this.desc);
}

@JsonSerializable()
class ContactTypeModel {
  @JsonKey(defaultValue: '')
  String name;

  @JsonKey(defaultValue: 0)
  int id;

  ContactTypeModel(
    this.name,
    this.id,
  );

  factory ContactTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ContactTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactTypeModelToJson(this);
}
