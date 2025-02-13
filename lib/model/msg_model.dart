import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/msg_reply_model.dart';
import 'msg_body_model.dart';
import 'msg_mark_model.dart';

part 'msg_model.g.dart';

enum MessageModelType {
  text(1),
  recall(2),
  image(3),
  file(4),
  audio(5),
  video(6),
  emoji(7),
  system(8),
  ;

  final int code;

  const MessageModelType(this.code);

  static MessageModelType? fromCode(int code) {
    for (var e in MessageModelType.values) {
      if (code == e.code) {
        return e;
      }
    }
    return null;
  }
}

enum MessageStatus {
  none(0),
  delivering(1),
  succeed(2),
  failed(3),
  ;

  final int code;

  const MessageStatus(this.code);

  static MessageStatus? fromCode(int code) {
    for (var e in MessageStatus.values) {
      if (code == e.code) {
        return e;
      }
    }
    return null;
  }
}

@JsonSerializable()
class MessageModel {
  @JsonKey(defaultValue: 0)
  int id;

  @JsonKey(defaultValue: 0)
  int roomId;

  @JsonKey(defaultValue: 0)
  int senderId;

  @JsonKey(defaultValue: '')
  String senderName;

  @JsonKey(defaultValue: '')
  String senderAvatar;

  @JsonKey(defaultValue: 0)
  int msgType;

  @JsonKey(defaultValue: 0)
  int sendTime;

  @JsonKey(fromJson: defaultMessageMarkModel)
  MessageMarkModel messageMark;

  @JsonKey(fromJson: defaultMessageReplyModel)
  MessageReplyModel reply;

  @JsonKey(fromJson: defaultMessageBodyModel)
  MessageBodyModel body;

  /// 发送消息标识消息id 用于更新
  @JsonKey(defaultValue: '')
  String messageId;

  /// 发送消息时消息的状态
  @JsonKey(defaultValue: 0)
  int status;

  MessageModel(
    this.id,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.messageId,
    this.sendTime,
    this.roomId,
    this.msgType,
    this.status,
    this.messageMark,
    this.reply,
    this.body,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

MessageModel defaultMessageModel(var value) {
  if (value == null) {
    return MessageModel.fromJson({});
  }
  return MessageModel.fromJson(value);
}
