// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageListResp _$MessageListRespFromJson(Map<String, dynamic> json) =>
    MessageListResp(
      json['cursor'] as String? ?? '',
      json['isLast'] as bool? ?? false,
      (json['list'] as List<dynamic>?)
              ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$MessageListRespToJson(MessageListResp instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'isLast': instance.isLast,
      'list': instance.list,
    };
