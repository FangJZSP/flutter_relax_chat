// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_mark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageMarkModel _$MessageMarkModelFromJson(Map<String, dynamic> json) =>
    MessageMarkModel(
      (json['likeCount'] as num?)?.toInt() ?? 0,
      (json['userLike'] as num?)?.toInt() ?? 0,
      (json['dislikeCount'] as num?)?.toInt() ?? 0,
      (json['userDislike'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MessageMarkModelToJson(MessageMarkModel instance) =>
    <String, dynamic>{
      'likeCount': instance.likeCount,
      'userLike': instance.userLike,
      'dislikeCount': instance.dislikeCount,
      'userDislike': instance.userDislike,
    };
