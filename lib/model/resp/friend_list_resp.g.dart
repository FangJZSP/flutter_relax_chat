// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendListResp _$FriendListRespFromJson(Map<String, dynamic> json) =>
    FriendListResp(
      (json['list'] as List<dynamic>?)
              ?.map((e) => FriendModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$FriendListRespToJson(FriendListResp instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) => FriendModel(
      (json['friendId'] as num?)?.toInt() ?? 0,
      json['name'] as String? ?? '',
      json['avatar'] as String? ?? '',
      (json['createTime'] as num?)?.toInt() ?? 0,
      json['message'] as String? ?? '',
      (json['status'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FriendModelToJson(FriendModel instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'name': instance.name,
      'avatar': instance.avatar,
      'createTime': instance.createTime,
      'message': instance.message,
      'status': instance.status,
    };
