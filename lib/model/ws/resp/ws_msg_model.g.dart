// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_msg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSBaseResponseModel _$WSBaseResponseModelFromJson(Map<String, dynamic> json) =>
    WSBaseResponseModel(
      (json['type'] as num?)?.toInt() ?? -1,
      json['res'],
    );

Map<String, dynamic> _$WSBaseResponseModelToJson(
        WSBaseResponseModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'res': instance.res,
    };

WSLoginSuccessModel _$WSLoginSuccessModelFromJson(Map<String, dynamic> json) =>
    WSLoginSuccessModel(
      (json['uid'] as num?)?.toInt() ?? -1,
      json['token'] as String? ?? '',
    );

Map<String, dynamic> _$WSLoginSuccessModelToJson(
        WSLoginSuccessModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'token': instance.token,
    };

WSFriendApplyModel _$WSFriendApplyModelFromJson(Map<String, dynamic> json) =>
    WSFriendApplyModel(
      (json['uid'] as num?)?.toInt() ?? -1,
      (json['unreadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WSFriendApplyModelToJson(WSFriendApplyModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'unreadCount': instance.unreadCount,
    };

WSBlackModel _$WSBlackModelFromJson(Map<String, dynamic> json) => WSBlackModel(
      (json['uid'] as num?)?.toInt() ?? -1,
    );

Map<String, dynamic> _$WSBlackModelToJson(WSBlackModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
    };

WSMessageModel _$WSMessageModelFromJson(Map<String, dynamic> json) =>
    WSMessageModel(
      defaultMessageModel(json['msg']),
    );

Map<String, dynamic> _$WSMessageModelToJson(WSMessageModel instance) =>
    <String, dynamic>{
      'msg': instance.msg,
    };
