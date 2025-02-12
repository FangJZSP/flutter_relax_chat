import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common.dart';

enum InputBarState { normal, keyboardShow, pendingSend }

class ChatInput extends StatefulWidget {
  final TextEditingController? editingController;
  final FocusNode? focusNode;
  final Function()? onClickInput;
  final Function(String)? sendCallback;
  final Function()? onTypingCallback;
  final String? placeHolder;
  final TextStyle? hintStyle;
  final Color? bgColor;

  const ChatInput({
    this.focusNode,
    this.editingController,
    this.hintStyle,
    this.bgColor,
    this.placeHolder,
    this.onClickInput,
    this.sendCallback,
    this.onTypingCallback,
    super.key,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  RxString inputText = ''.obs;

  Rx<InputBarState> inputState = InputBarState.normal.obs;

  RxBool get keyboardShow =>
      (inputState.value == InputBarState.keyboardShow).obs;

  @override
  void initState() {
    super.initState();
    widget.editingController?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus ?? false) {
        inputState.value = InputBarState.keyboardShow;
      } else {
        inputState.value = InputBarState.normal;
      }
    });
  }

  void _onTapInputFiled() {
    inputState.value = inputState.value = InputBarState.keyboardShow;
    widget.onClickInput?.call();
  }

  void _onClickRightButton() {
    _onSendMsg(widget.editingController?.text ?? '');
    widget.focusNode?.requestFocus();
  }

  void _onSendMsg(String text) async {
    if (text.isEmpty) {
      return;
    }
    widget.sendCallback?.call(text);
    widget.editingController?.clear();
    if (widget.focusNode?.hasFocus ?? false) {
      if (widget.editingController?.text.isEmpty ?? false) {
        inputState.value = InputBarState.keyboardShow;
      }
    } else {
      inputState.value = InputBarState.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        constraints: const BoxConstraints(
          maxHeight: 100.0,
          minHeight: 38.0,
        ),
        decoration: BoxDecoration(
          color: widget.bgColor ?? Styles.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 9,
            ),
            Expanded(
              child: TextField(
                onTap: _onTapInputFiled,
                scrollPhysics: const BouncingScrollPhysics(),
                controller: widget.editingController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (String text) {
                  inputText.value = text;
                  widget.onTypingCallback?.call();
                },
                focusNode: widget.focusNode,
                enabled: true,
                keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.newline,
                style: null,
                cursorColor: Styles.black,
                cursorWidth: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: widget.placeHolder ?? Strings.hintText,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 9),
                  hintStyle: widget.hintStyle ??
                      Styles.textNormal(16).copyWith(color: Styles.greyText),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                ),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            _rightButton(),
            const SizedBox(
              width: 9,
            ),
          ],
        ),
      );
    });
  }

  Widget _rightButton() {
    return GestureDetector(
      onTap: _onClickRightButton,
      child: Icon(
        Icons.send,
        color: inputText.isEmpty ? Styles.grey : Styles.blueAccent,
      ),
    );
  }
}
