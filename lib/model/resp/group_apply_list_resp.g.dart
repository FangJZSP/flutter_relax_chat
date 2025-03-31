// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_apply_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupApplyListResp _$GroupApplyListRespFromJson(Map<String, dynamic> json) =>
    GroupApplyListResp(
      (json['list'] as List<dynamic>?)
              ?.map((e) => GroupApplyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      (json['size'] as num?)?.toInt() ?? 20,
      (json['page'] as num?)?.toInt() ?? 1,
      (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GroupApplyListRespToJson(GroupApplyListResp instance) =>
    <String, dynamic>{
      'list': instance.list,
      'size': instance.size,
      'page': instance.page,
      'total': instance.total,
    };

GroupApplyModel _$GroupApplyModelFromJson(Map<String, dynamic> json) =>
    GroupApplyModel(
      (json['id'] as num?)?.toInt() ?? 0,
      (json['userId'] as num?)?.toInt() ?? 0,
      (json['roomId'] as num?)?.toInt() ?? 0,
      json['groupName'] as String? ?? '',
      json['groupAvatar'] as String? ?? '',
      json['name'] as String? ?? '',
      json['avatar'] as String? ?? '',
      json['message'] as String? ?? '',
      (json['status'] as num?)?.toInt() ?? 0,
      (json['createTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GroupApplyModelToJson(GroupApplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'roomId': instance.roomId,
      'groupName': instance.groupName,
      'groupAvatar': instance.groupAvatar,
      'name': instance.name,
      'avatar': instance.avatar,
      'message': instance.message,
      'status': instance.status,
      'createTime': instance.createTime,
    };
