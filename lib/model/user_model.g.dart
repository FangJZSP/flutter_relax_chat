// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      (json['uid'] as num?)?.toInt() ?? 0,
      json['name'] as String? ?? '',
      json['avatar'] as String? ?? '',
      (json['sex'] as num?)?.toInt() ?? 0,
      (json['modifyNameChance'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'avatar': instance.avatar,
      'sex': instance.sex,
      'modifyNameChance': instance.modifyNameChance,
    };
