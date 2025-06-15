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
      json['url'] as String? ?? '',
      (json['width'] as num?)?.toInt() ?? 0,
      (json['height'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MessageBodyModelToJson(MessageBodyModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'urlContentMap': instance.urlContentMap,
      'atUidList': instance.atUidList,
      'reply': instance.reply,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
