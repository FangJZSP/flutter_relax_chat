// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCellModel _$MessageCellModelFromJson(Map<String, dynamic> json) =>
    MessageCellModel(
      messageModel: defaultWSMessageModel(json['messageModel']),
      msgCellType:
          $enumDecodeNullable(_$MessageCellTypeEnumMap, json['msgCellType']) ??
              MessageCellType.addNew,
      messageId: json['messageId'] as String? ?? '',
      cachedMsg: json['cachedMsg'] as bool? ?? false,
      status: (json['status'] as num?)?.toInt() ?? 0,
      chatMarker: (json['chatMarker'] as num?)?.toInt(),
      insertIndex: (json['insertIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageCellModelToJson(MessageCellModel instance) =>
    <String, dynamic>{
      'messageModel': instance.messageModel,
      'msgCellType': _$MessageCellTypeEnumMap[instance.msgCellType]!,
      'messageId': instance.messageId,
      'cachedMsg': instance.cachedMsg,
      'status': instance.status,
      'chatMarker': instance.chatMarker,
      'insertIndex': instance.insertIndex,
    };

const _$MessageCellTypeEnumMap = {
  MessageCellType.addNew: 'addNew',
  MessageCellType.addOld: 'addOld',
  MessageCellType.update: 'update',
  MessageCellType.chatMarker: 'chatMarker',
  MessageCellType.composing: 'composing',
  MessageCellType.insert: 'insert',
};
