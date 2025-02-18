// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactTypeModel _$ContactTypeModelFromJson(Map<String, dynamic> json) =>
    ContactTypeModel(
      json['name'] as String? ?? '',
      (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ContactTypeModelToJson(ContactTypeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
