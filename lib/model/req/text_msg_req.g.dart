// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_msg_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMsgReq _$TextMsgReqFromJson(Map<String, dynamic> json) => TextMsgReq(
      json['content'] as String? ?? '',
      (json['replyMsgId'] as num?)?.toInt(),
      (json['atUidList'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
    );

Map<String, dynamic> _$TextMsgReqToJson(TextMsgReq instance) =>
    <String, dynamic>{
      'content': instance.content,
      'replyMsgId': instance.replyMsgId,
      'atUidList': instance.atUidList,
    };
