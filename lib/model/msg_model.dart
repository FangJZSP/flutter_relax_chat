import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/msg_reply_model.dart';
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
  int senderId;

  @JsonKey(defaultValue: '')
  String senderName;

  @JsonKey(defaultValue: '')
  String senderAvatar;

  @JsonKey(defaultValue: 0)
  int roomId;

  @JsonKey(defaultValue: 0)
  int msgType;

  @JsonKey(defaultValue: 0)
  int status;

  @JsonKey(defaultValue: 0)
  int sendTime;

  @JsonKey(fromJson: defaultMessageMarkModel)
  MessageMarkModel messageMark;

  @JsonKey(fromJson: defaultMessageReplyModel)
  MessageReplyModel reply;

  @JsonKey(defaultValue: '')
  String messageId;

  // todo 判断消息类型
  dynamic body;

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

  T? getBodyModel<T>() {
    switch (MessageModelType.fromCode(msgType)) {
      case MessageModelType.text:
        if (body is T) {
          return body;
        } else {
          return TextMessageModel.fromJson(body) as T?;
        }
      default:
        return null;
    }
  }

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

@JsonSerializable()
class TextMessageModel {
  @JsonKey(defaultValue: '')
  String content;

  @JsonKey(defaultValue: {})
  Map<String, dynamic> urlContentMap;

  @JsonKey(defaultValue: [])
  List<int> atUidList;

  @JsonKey(fromJson: defaultMessageReplyModel)
  MessageReplyModel reply;

  TextMessageModel(
      this.content, this.urlContentMap, this.atUidList, this.reply);

  factory TextMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TextMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextMessageModelToJson(this);
}
