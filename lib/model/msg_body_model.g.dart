// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageBodyModel _$MessageBodyModelFromJson(Map<String, dynamic> json) =>
    MessageBodyModel(
      json['content'] as String? ?? '',
      json['urlContentMap'] as Map<String, dynamic>? ?? {},
      (json['atUidList'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      defaultMessageReplyModel(json['reply']),
    );

Map<String, dynamic> _$MessageBodyModelToJson(MessageBodyModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'urlContentMap': instance.urlContentMap,
      'atUidList': instance.atUidList,
      'reply': instance.reply,
    };
