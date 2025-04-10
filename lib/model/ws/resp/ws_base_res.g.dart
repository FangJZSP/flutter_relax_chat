// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_base_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSBaseResponseModel _$WSBaseResponseModelFromJson(Map<String, dynamic> json) =>
    WSBaseResponseModel(
      (json['type'] as num?)?.toInt() ?? -1,
      json['res'],
    );

Map<String, dynamic> _$WSBaseResponseModelToJson(
        WSBaseResponseModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'res': instance.res,
    };
