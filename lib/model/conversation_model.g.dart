// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      (json['conversationId'] as num?)?.toInt() ?? 0,
      (json['roomId'] as num?)?.toInt() ?? 0,
      (json['activeTime'] as num?)?.toInt() ?? 0,
      json['avatar'] as String? ?? '',
      (json['type'] as num?)?.toInt() ?? 0,
      json['name'] as String? ?? '',
      json['text'] as String? ?? '',
      (json['unreadCount'] as num?)?.toInt() ?? 0,
      (json['readTime'] as num?)?.toInt() ?? 0,
      (json['lastMsgId'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'roomId': instance.roomId,
      'avatar': instance.avatar,
      'type': instance.type,
      'name': instance.name,
      'text': instance.text,
      'unreadCount': instance.unreadCount,
      'activeTime': instance.activeTime,
      'readTime': instance.readTime,
      'lastMsgId': instance.lastMsgId,
    };
