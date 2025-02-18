// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      (json['id'] as num?)?.toInt() ?? 0,
      (json['senderId'] as num?)?.toInt() ?? 0,
      json['senderName'] as String? ?? '',
      json['senderAvatar'] as String? ?? '',
      json['messageId'] as String? ?? '',
      (json['sendTime'] as num?)?.toInt() ?? 0,
      (json['roomId'] as num?)?.toInt() ?? 0,
      (json['msgType'] as num?)?.toInt() ?? 0,
      (json['status'] as num?)?.toInt() ?? 0,
      defaultMessageMarkModel(json['messageMark']),
      defaultMessageReplyModel(json['reply']),
      defaultMessageBodyModel(json['body']),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'msgType': instance.msgType,
      'sendTime': instance.sendTime,
      'messageMark': instance.messageMark,
      'reply': instance.reply,
      'body': instance.body,
      'messageId': instance.messageId,
      'status': instance.status,
    };
