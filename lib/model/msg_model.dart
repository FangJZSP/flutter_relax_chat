import 'package:json_annotation/json_annotation.dart';
import 'package:relax_chat/model/msg_reply_model.dart';
import '../manager/user_manager.dart';
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

  MessageModel(
    this.id,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.sendTime,
    this.roomId,
    this.msgType,
    this.messageMark,
    this.reply,
    this.body,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  bool get senderIsMe {
    return senderId == UserManager.instance.state.user.value.uid;
  }
}

MessageModel defaultMessageModel(var value) {
  if (value == null) {
    return MessageModel.fromJson({});
  }
  return MessageModel.fromJson(value);
}
