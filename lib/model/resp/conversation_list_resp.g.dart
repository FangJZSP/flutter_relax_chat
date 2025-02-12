// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationListResp _$ConversationListRespFromJson(
        Map<String, dynamic> json) =>
    ConversationListResp(
      json['cursor'] as String? ?? '',
      json['isLast'] as bool? ?? false,
      (json['list'] as List<dynamic>?)
              ?.map(
                  (e) => ConversationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ConversationListRespToJson(
        ConversationListResp instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'isLast': instance.isLast,
      'list': instance.list,
    };
