// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CacheFileModel _$CacheFileModelFromJson(Map<String, dynamic> json) =>
    CacheFileModel(
      url: json['url'] as String? ?? '',
      path: json['path'] as String? ?? '',
      saveTime: (json['saveTime'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$CacheFileModelToJson(CacheFileModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'path': instance.path,
      'saveTime': instance.saveTime,
      'type': instance.type,
    };
