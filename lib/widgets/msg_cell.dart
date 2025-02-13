import 'package:flutter/material.dart';
import 'package:relax_chat/model/msg_model.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';

import '../common/common.dart';
import '../common/styles.dart';
import 'image/round_avatar.dart';

class MsgCell extends StatefulWidget {
  final WSMessageModel model;

  const MsgCell({
    required this.model,
    super.key,
  });

  @override
  State<MsgCell> createState() => _MsgCellState();
}

class _MsgCellState extends State<MsgCell> {
  late WSMessageModel _model;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return _msgCell();
  }

  @override
  void didUpdateWidget(covariant MsgCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _model = widget.model;
  }

  Widget _msgCell() {
    switch (MessageModelType.fromCode(_model.msg.msgType)) {
      case MessageModelType.text:
        return _model.senderIsMe ? sendMsgCell() : receiveMsgCell();
      case MessageModelType.system:
        return systemMsgCell();
      case null:
      default:
        return const Text('消息气泡暂未处理这种类型');
    }
  }

  Widget sendMsgCell() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_model.msg.senderName}(${_model.msg.senderId})',
                style: Styles.textNormal(10).copyWith(color: Styles.greyText),
              ),
              const SizedBox(
                height: 4,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 264,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Styles.sendBubbleColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_model.msg.reply.id != 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '| ${_model.msg.reply.username}: ${_model.msg.reply.body}',
                              style: Styles.textNormal(14)
                                  .copyWith(color: Styles.grey),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        Text(
                          _model.msg.body.content,
                          style: Styles.textNormal(14)
                              .copyWith(color: Styles.black),
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    left: -18,
                    child: msgStatus(),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          RoundAvatar(
            height: 35,
            url: _model.msg.senderAvatar,
            borderDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Styles.grey.withOpacity(.1),
                )),
          ),
        ],
      ),
    );
  }

  Widget msgStatus() {
    if (_model.msg.status == MessageStatus.delivering.code) {
      return const SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      );
    } else if (_model.msg.status == MessageStatus.succeed.code) {
      // return Icon(
      //   Icons.check_circle_outline,
      //   size: 14,
      //   color: Styles.grey,
      // );
      return Container();
    } else if (_model.msg.status == MessageStatus.failed.code) {
      return const Icon(
        Icons.error,
        size: 14,
        color: Styles.red,
      );
    } else {
      return Container();
    }
  }

  Widget receiveMsgCell() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundAvatar(
            height: 35,
            url: _model.msg.senderAvatar,
            borderDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Styles.grey.withOpacity(.1),
                )),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _model.msg.senderName,
                style: Styles.textNormal(10).copyWith(color: Styles.greyText),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 264,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Styles.receiveBubbleColor,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_model.msg.reply.id != 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '| ${_model.msg.reply.username}: ${_model.msg.reply.body}',
                          style: Styles.textNormal(14)
                              .copyWith(color: Styles.grey),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    Text(
                      _model.msg.body.content,
                      style:
                          Styles.textNormal(14).copyWith(color: Styles.black),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget systemMsgCell() {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: const BoxDecoration(
            color: Styles.transparent,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Text(
          _model.msg.body.toString(),
          style: Styles.textNormal(12).copyWith(color: Styles.greyText),
        ));
  }
}
