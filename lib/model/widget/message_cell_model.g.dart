// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCellModel _$MessageCellModelFromJson(Map<String, dynamic> json) =>
    MessageCellModel(
      defaultMessageModel(json['messageModel']),
      $enumDecodeNullable(_$MessageCellTypeEnumMap, json['msgCellType']) ??
          MessageCellType.addNew,
      json['messageId'] as String? ?? '',
      json['cachedMsg'] as bool? ?? false,
      (json['status'] as num?)?.toInt() ?? 0,
      (json['chatMarker'] as num?)?.toInt(),
      (json['insertIndex'] as num?)?.toInt(),
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
