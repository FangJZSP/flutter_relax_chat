// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageReplyModel _$MessageReplyModelFromJson(Map<String, dynamic> json) =>
    MessageReplyModel(
      (json['id'] as num?)?.toInt() ?? 0,
      json['username'] as String? ?? '',
      json['content'] as String? ?? '',
      json['body'] as String? ?? '',
      (json['canCallback'] as num?)?.toInt() ?? 0,
      (json['gapCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MessageReplyModelToJson(MessageReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'content': instance.content,
      'body': instance.body,
      'canCallback': instance.canCallback,
      'gapCount': instance.gapCount,
    };
