import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../app.export.dart';
import 'math_utils.dart';

class CommonTextfield extends StatefulWidget {
  final TextFieldOption textOption;
  final Function(String text) textCallback;
  final VoidCallback tapCallback;
  final VoidCallback onNextPress;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final bool showUnderLine;
  final bool enable;
  final bool autoFocus;
  final bool autoCorrect;
  final bool alignment;
  final String lableText;
  final Function(String text) validation;
  TextStyle hintStyleText;

  CommonTextfield({
    @required this.textOption,
    @required this.textCallback,
    this.tapCallback,
    this.onNextPress,
    this.inputAction,
    this.autoFocus,
    this.focusNode,
    this.alignment,
    this.showUnderLine = true,
    this.enable = true,
    this.validation,
    this.autoCorrect = true,
    this.hintStyleText,
    this.lableText = "",
  });

  @override
  _CommonTextfieldState createState() => _CommonTextfieldState();
}

class _CommonTextfieldState extends State<CommonTextfield> {
  bool obscureText = false;
  IconData obscureIcon = Icons.visibility;

  @override
  void initState() {
    super.initState();

    obscureText = widget.textOption.isSecureTextField ?? false;
  }

  @override
  void didUpdateWidget(CommonTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.only(bottom: getSize(10)),
        //   child: Text(
        //     widget.lableText,
        //     style: appTheme.black_Medium_16Text,
        //   ),
        // ),
        TextFormField(
          textAlignVertical: TextAlignVertical(y: 0.1),
          autocorrect: widget.autoCorrect,
          enabled: widget.enable,
          onTap: widget.tapCallback,
          maxLines: widget.textOption.maxLine,
          textInputAction: widget.inputAction ?? TextInputAction.done,
          focusNode: widget.focusNode ?? null,
          autofocus: widget.autoFocus ?? false,
          controller: widget.textOption.inputController ?? null,
          obscureText: this.obscureText,
          style: appTheme.grey_Medium_14Text,
          keyboardType: widget.textOption.keyboardType ?? TextInputType.text,
          textCapitalization:
              widget.textOption.textCapitalization ?? TextCapitalization.none,
          cursorColor: appTheme.colorPrimary,
          inputFormatters: widget.textOption.formatter ?? [],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              top: getSize(16),
              bottom: getSize(16),
              left: getSize(16),
            ),
            errorMaxLines: 2,
            errorStyle: appTheme.errorText,
            fillColor: widget.textOption.fillColor ?? fromHex("#F6F6F6"),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(getSize(widget.textOption.radious ?? 10))),
              borderSide: BorderSide(
                color: Colors.white,
                width: 0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(getSize(widget.textOption.radious ?? 10))),
              borderSide: BorderSide(
                color: Colors.white,
                width: 0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(getSize(widget.textOption.radious ?? 10))),
              borderSide: BorderSide(
                color: Colors.white,
                width: 0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.textOption.radious ?? 10)),
              borderSide: BorderSide(
                color: Colors.white,
                //  width: getSize(0.5),
              ),
            ),
            hintStyle: appTheme.grey_Medium_14Text,
            hintText: widget.textOption.hintText,
            prefixIcon: widget.textOption.prefixWid,
            suffix: widget.textOption.postfixWidOnFocus,
            suffixIcon: (widget.textOption.isSecureTextField != null &&
                    widget.textOption.isSecureTextField)
                ? InkWell(
                    onTap: () {
                      setState(() {
                        this.obscureText = !this.obscureText;
                        if (!widget.focusNode.hasPrimaryFocus)
                          widget.focusNode.canRequestFocus = false;
                        widget.focusNode.unfocus();
                      });
                      //TextInputConnection;
                    },
                    child: Padding(
                      padding: EdgeInsets.all(getSize(15)),
                      // child: Image.asset(
                      //   !obscureText ? visible : invisible,
                      //   height: getSize(10),
                      //   width: getSize(15),
                      // ),
                    ),
                  )
                : widget.textOption.type == TextFieldType.DropDown
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                        ),
                      )
                    : widget.textOption.postfixWid,
          ),
          onFieldSubmitted: (String text) {
            this.widget.textCallback(text);
            FocusScope.of(context).unfocus();
            if (widget.onNextPress != null) {
              widget.onNextPress();
            }
          },
          validator: widget.validation,
          onChanged: (String text) {
            this.widget.textCallback(text);
          },
          onEditingComplete: () {
            this.widget.textCallback(widget.textOption.inputController.text);
          },
        ),
      ],
    );
  }
}

class TextFieldOption {
  String text = "";
  String labelText;
  String hintText;
  bool isSecureTextField = false;
  TextInputType keyboardType;
  TextFieldType type;
  int maxLine;
  TextStyle hintStyleText;
  Widget prefixWid;
  Widget postfixWid;
  Widget postfixWidOnFocus;
  bool autoFocus;
  Color fillColor;
  InputBorder errorBorder;
  List<TextInputFormatter> formatter;
  TextEditingController inputController;
  TextCapitalization textCapitalization;
  double radious;

  TextFieldOption(
      {this.text,
      this.labelText,
      this.hintText,
      this.isSecureTextField,
      this.keyboardType,
      this.type,
      this.maxLine = 1,
      this.autoFocus,
      this.formatter,
      this.hintStyleText,
      this.inputController,
      this.prefixWid,
      this.postfixWid,
      this.postfixWidOnFocus,
      this.fillColor,
      this.errorBorder,
      this.textCapitalization,
      this.radious});
}

enum TextFieldType {
  Normal,
  DropDown,
}
