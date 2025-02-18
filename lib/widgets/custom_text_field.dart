import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/common.dart';

class CustomTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final Function()? onDone;
  final Function()? onPasteClick;
  final TextEditingController? controller;
  final String? placeholder;
  final int? maxLine;
  final int? maxCharacter;
  final bool showSign;
  final String title;
  final double titleTextSize;
  final double titleWidth;

  final bool enable;
  final EdgeInsets? scrollPadding;
  final FocusNode? focusNode;
  final bool maxLengthEnforced;
  final bool boxField;

  // 最大高度
  // 这个属性在 maxLine = null时生效, 输入框自适应文本高度,当达到这个高度后,高度不在增加.
  final double? maxHeight;

  // 边框宽度 默认.5
  final double enableBorderWidth;
  final double focusedBorderWidth;

  final bool needRequired;

  final int hintMaxLines;
  final double counterSize;
  final double bottomPadding;

  final TextStyle? inputTextStyle;
  final TextStyle? placeHolderTextStyle;
  final TextStyle? counterStyle;

  final double titleFontHeight;

  final TextAlign textAlign;

  final bool isDense;

  // 自定义counter
  final Widget? Function(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCustomCounter;

  final EdgeInsetsGeometry? contentPadding;

  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    this.onChanged,
    this.needRequired = false,
    this.controller,
    this.onDone,
    this.placeholder,
    this.maxLine,
    this.maxCharacter,
    this.titleFontHeight = 1.2,
    this.showSign = false,
    this.title = '',
    this.titleTextSize = 16,
    this.titleWidth = 140,
    this.enable = true,
    this.scrollPadding,
    this.onPasteClick,
    this.focusNode,
    this.maxHeight,
    this.maxLengthEnforced = true,
    this.boxField = false,
    this.enableBorderWidth = .5,
    this.focusedBorderWidth = 1.5,
    this.hintMaxLines = 20,
    this.counterSize = 12,
    this.bottomPadding = 0,
    this.inputTextStyle,
    this.placeHolderTextStyle,
    this.counterStyle,
    this.textAlign = TextAlign.left,
    this.isDense = true,
    this.buildCustomCounter,
    this.keyboardType,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    BoxConstraints? constraints;
    TextStyle inputTs = inputTextStyle ?? Styles.textNormal(14);
    TextStyle placeHolderTs = placeHolderTextStyle ?? Styles.textNormal(14);

    if (maxHeight != null) {
      constraints = BoxConstraints(
        minHeight: 40,
        maxHeight: maxHeight! + 30, // 加上30，包括了底部下划线和计数的高度
        minWidth: SizeConfig.screenWidth,
        maxWidth: SizeConfig.screenWidth,
      );
    }

    if (boxField) {
      return Column(
        children: [
          if (title.isNotEmpty)
            Column(
              children: [
                Container(
                  height: 40,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    textScaler: TextScaler.noScaling,
                    style: Styles.textNormal(titleTextSize)
                        .copyWith(height: titleFontHeight),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          Container(
            constraints: constraints,
            child: TextField(
              buildCounter: buildCustomCounter,
              textAlign: textAlign,
              scrollPhysics: const BouncingScrollPhysics(),
              controller: controller,
              maxLength: maxCharacter,
              maxLines: maxLine,
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.sentences,
              maxLengthEnforcement: maxLengthEnforced
                  ? MaxLengthEnforcement.enforced
                  : MaxLengthEnforcement.none,
              onChanged: (str) {
                onChanged?.call(str);
              },
              onEditingComplete: () {
                onDone?.call();
              },
              enabled: enable,
              focusNode: focusNode,
              keyboardAppearance: Brightness.light,
              textInputAction: TextInputAction.newline,

              ///不显示输入时正在编辑单词的下划线（修改decorationColor还是有）
              style: inputTs.copyWith(
                decorationThickness: 0,
              ),
              cursorWidth: 3,
              cursorColor: Styles.greyBgColor,
              decoration: InputDecoration(
                contentPadding: contentPadding,
                filled: true,
                fillColor: Styles.greyBgColor,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    color: Styles.transparent,
                    width: 0.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    color: Styles.transparent,
                    width: 1,
                  ),
                ),
                hintText: placeholder,
                counterStyle: counterStyle ?? Styles.textLight(counterSize),
                hintMaxLines: 20,
                //使初始高度能看到hint，尽量给的大值
                hintStyle: placeHolderTs,
              ),
              scrollPadding:
                  scrollPadding ?? EdgeInsets.all(20.0 * (maxLine ?? 0) + 15),
            ),
          )
        ],
      );
    }

    return Container(
      constraints: constraints,
      child: TextField(
        buildCounter: buildCustomCounter,
        textAlign: textAlign,
        scrollPhysics: const BouncingScrollPhysics(),
        controller: controller,
        maxLength: maxCharacter,
        maxLines: maxLine,
        maxLengthEnforcement: maxLengthEnforced
            ? MaxLengthEnforcement.enforced
            : MaxLengthEnforcement.none,
        onChanged: (str) {
          onChanged?.call(str);
        },
        enabled: enable,
        focusNode: focusNode,
        keyboardAppearance: Brightness.light,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.sentences,

        /// 不显示输入时正在编辑单词的下划线（修改decorationColor还是有）
        style: inputTs.copyWith(
          decorationThickness: 0,
        ),
        cursorColor: Styles.greyBgColor,
        cursorWidth: 3,
        decoration: InputDecoration(
          isDense: isDense,
          contentPadding: EdgeInsets.only(bottom: bottomPadding),
          prefixIcon: Container(
              padding: EdgeInsets.only(bottom: bottomPadding),
              alignment: Alignment.centerLeft,
              width: titleWidth,
              child: RichText(
                  textScaler: TextScaler.noScaling,
                  text: TextSpan(children: [
                    TextSpan(
                      text: title,
                      style: Styles.textNormal(
                        titleTextSize,
                      ).copyWith(height: titleFontHeight),
                    ),
                    if (needRequired)
                      TextSpan(
                        text: '*',
                        style: Styles.textNormal(titleTextSize).copyWith(
                            height: titleFontHeight,
                            color: const Color.fromRGBO(255, 126, 126, 1)),
                      ),
                  ]))),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 27),
          hintText: placeholder,
          counterStyle: counterStyle ?? Styles.textLight(counterSize),
          hintMaxLines: hintMaxLines,
          //使初始高度能看到hint，尽量给的大值
          hintStyle: placeHolderTs,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Styles.greyBgColor, width: focusedBorderWidth),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Styles.greyBgColor, width: enableBorderWidth)),
        ),
        scrollPadding:
            scrollPadding ?? EdgeInsets.all(20.0 * (maxLine ?? 0) + 15),
        keyboardType: keyboardType,
      ),
    );
  }
}
