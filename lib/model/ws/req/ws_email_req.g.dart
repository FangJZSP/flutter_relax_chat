// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_email_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSEmailReq _$WSEmailReqFromJson(Map<String, dynamic> json) => WSEmailReq(
      (json['type'] as num).toInt(),
      defaultEmailData(json['req']),
    );

Map<String, dynamic> _$WSEmailReqToJson(WSEmailReq instance) =>
    <String, dynamic>{
      'type': instance.type,
      'req': instance.req,
    };

EmailData _$EmailDataFromJson(Map<String, dynamic> json) => EmailData(
      json['email'] as String? ?? '',
      json['needCode'] as bool? ?? false,
    );

Map<String, dynamic> _$EmailDataToJson(EmailData instance) => <String, dynamic>{
      'email': instance.email,
      'needCode': instance.needCode,
    };
