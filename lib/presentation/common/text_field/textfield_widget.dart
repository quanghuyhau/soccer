import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer/generated/assets.dart';
import 'package:soccer/presentation/common/load_image/load_image.dart';
import 'package:soccer/utilities/extensions/extensions.dart';
import 'package:soccer/utilities/style/style.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final String? hintText;
  final bool autofocus;
  final VoidCallback? beginEditing;
  final ValueChanged<String>? valueChanged;
  final TextCapitalization textCapitalization;
  final String? description;
  final bool obscureText;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool isDisable;
  final String? initialText;
  final bool needSelect;
  final TextInputType? keyboardType;
  final double? height;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final TextStyle? style;
  final bool enableInteractiveSelection;
  final int? maxLength;
  final VoidCallback? onClear;
  final VoidCallback? onCompleted;
  final RegExp? regExp;
  final String? errorMessage;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final TextStyle? labelTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final String counterText;
  final TextStyle? counterStyle;
  final bool? isDisableDeleteAll;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final bool? hasError;
  final Function(TextEditingController currentController)? onHandlerController;
  final Color? unFocusBorderColor;
  final bool? required;

  final VoidCallback? onTap;

  final Function()? onDispose;

  final Function(String text)? onHandleListener;

  factory AppTextField.dropDownTextfield({
    TextEditingController? controller,
    String? label,
    String? hintText,
    TextStyle? labelTextStyle,
    String? initialText,
    String? description,
    VoidCallback? onTap,
    double? height,
    bool? required,
  }) =>
      AppTextField(
        controller: controller,
        onTap: onTap,
        label: label,
        hintText: hintText,
        labelTextStyle: labelTextStyle,
        initialText: initialText,
        needSelect: true,
        rightIcon: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: LoadImage(
              url: Assets.iconsArrowDown,
              width: 24,
              height: 24,
              colors: theme.color.b20,
            ),
          ),
        ),
        description: description,
        required: required,
      );

  const AppTextField({
    this.height = 40,
    this.label,
    this.controller,
    this.hintText,
    this.autofocus = false,
    this.obscureText = false,
    this.beginEditing,
    this.valueChanged,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.description,
    this.leftIcon,
    this.rightIcon,
    this.initialText,
    this.needSelect = false,
    this.isDisable = false,
    this.textAlign = TextAlign.left,
    this.backgroundColor,
    Key? key,
    this.focusNode,
    this.style,
    this.enableInteractiveSelection = true,
    this.inputFormatters,
    this.maxLength,
    this.onClear,
    this.onCompleted,
    this.regExp,
    this.errorMessage,
    this.maxLines = 1,
    this.labelTextStyle,
    this.onHandlerController,
    this.hintStyle,
    this.counterStyle,
    this.counterText = '',
    this.isDisableDeleteAll,
    this.padding,
    this.contentPadding,
    this.decoration,
    this.hasError,
    this.unFocusBorderColor,
    this.required = false,
    this.onTap,
    this.onDispose,
    this.onHandleListener,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool onEditing = false;
  bool hasError = false;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_updateFocusNote);
    _controller.addListener(() {
      widget.onHandleListener ??
          setState(() {
            hasError = _controller.text.isNullOrEmpty
                ? false
                : !(widget.regExp?.hasMatch(_controller.text) ?? true);
          });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    widget.onHandlerController?.call(_controller);
    super.didUpdateWidget(oldWidget);
  }

  void _updateFocusNote() {
    setState(() {
      onEditing = _focusNode.hasFocus && _controller.text.isNotEmpty;
    });
    if (!_focusNode.hasFocus) {
      widget.onCompleted?.call();
    }
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!.call();
    } else {
      _focusNode.removeListener(_updateFocusNote);

      _controller.dispose();

      _focusNode.dispose();
    }

    super.dispose();
  }

  Widget _descriptionArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          LoadImage(
            url: Assets.iconsInfo,
            width: 16,
            height: 16,
            colors: widget.isDisable ? theme.color.b50 : theme.color.b60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(widget.description ?? '',
                style: theme.font.note.copyWith(color: theme.color.b60)),
          ),
        ],
      ),
    );
  }

  Widget _errorText() => Text(
        widget.errorMessage ?? '',
        style: theme.font.note.copyWith(
          color: theme.color.red500,
        ),
      );

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    final backgroundColor = widget.backgroundColor ?? theme.color.b700;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.label!,
                    style: widget.labelTextStyle ??
                        theme.font.body.copyWith(color: theme.color.b60),
                  ),
                  if (widget.required == true)
                    TextSpan(
                      text: ' *',
                      style: widget.labelTextStyle ??
                          theme.font.body.copyWith(color: theme.color.c1),
                    ),
                ],
              ),
            ),
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Container(
            height: widget.height,
            padding: widget.padding,
            // padding: const EdgeInsets.symmetric(horizontal: PADDING_1X),
            decoration: widget.decoration ??
                BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: backgroundColor,
                  border: Border.all(
                    color: (widget.hasError ?? hasError)
                        ? theme.color.red500
                        : _focusNode.hasFocus
                            ? theme.color.gray100
                            : widget.unFocusBorderColor ?? theme.color.b500,
                  ),
                ),
            child: Row(
              children: [
                if (widget.leftIcon != null) widget.leftIcon!,
                Flexible(
                  child: TextFormField(
                      textAlign: widget.textAlign!,
                      keyboardType: widget.keyboardType,
                      initialValue: widget.initialText,
                      obscureText: widget.obscureText,
                      autofocus: widget.autofocus && !widget.isDisable,
                      textCapitalization: widget.textCapitalization,
                      inputFormatters: widget.inputFormatters,
                      maxLength: widget.maxLength,
                      controller: _controller,
                      enableInteractiveSelection:
                          widget.enableInteractiveSelection,
                      onTap: widget.beginEditing,
                      style: widget.style ??
                          (widget.isDisable
                              ? theme.font.note.copyWith(color: theme.color.b20)
                              : theme.font.note
                                  .copyWith(color: theme.color.b20)),
                      onChanged: (value) {
                        setState(() {
                          onEditing = true;
                        });
                        if (widget.valueChanged != null) {
                          widget.valueChanged!(value);
                        }
                      },
                      cursorColor: theme.color.c1,
                      maxLines: widget.maxLines,
                      decoration: InputDecoration(
                          counterText: widget.counterText,
                          counterStyle: widget.counterStyle,
                          hintText: widget.hintText,
                          hintStyle: widget.hintStyle ??
                              theme.font.note.copyWith(color: theme.color.b40),
                          contentPadding: widget.contentPadding ??
                              const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 8),
                          fillColor: backgroundColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabled: !widget.isDisable && !widget.needSelect),
                      focusNode: _focusNode),
                ),
                Visibility(
                  visible: widget.isDisableDeleteAll != true &&
                      onEditing &&
                      !_controller.text.isNullOrEmpty,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onClear?.call();
                      _controller.clear();
                      setState(() {});
                    },
                    child: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: LoadImage(
                          url: Assets.iconsClearTextField,
                          width: 16,
                          height: 16,
                        )),
                  ),
                ),
                if (widget.rightIcon != null)
                  Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: widget.rightIcon!),
              ],
            ),
          ),
        ),
        if (hasError) _errorText(),
        if (widget.description != null) _descriptionArea(context)
      ],
    );
  }
}
