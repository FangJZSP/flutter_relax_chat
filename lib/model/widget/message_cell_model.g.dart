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
      cachedMsg: json['cachedMsg'] as bool? ?? false,
      chatMarker: (json['chatMarker'] as num?)?.toInt(),
      insertIndex: (json['insertIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageCellModelToJson(MessageCellModel instance) =>
    <String, dynamic>{
      'messageModel': instance.messageModel,
      'chatMarker': instance.chatMarker,
      'msgCellType': _$MessageCellTypeEnumMap[instance.msgCellType]!,
      'cachedMsg': instance.cachedMsg,
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
