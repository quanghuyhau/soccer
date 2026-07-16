import 'package:flutter/material.dart';
import 'package:atm_soundbox/generated/assets.dart';
import 'package:atm_soundbox/presentation/common/load_image/load_image.dart';
import 'package:atm_soundbox/utilities/style/style.dart';
import 'textfield_widget.dart';

class PasswordTextField extends StatefulWidget {
  final String? label;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool hasError;
  final ValueChanged<String>? valueChanged;
  final VoidCallback? onClear;
  final bool? required;

  const PasswordTextField({
    super.key,
    this.label,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.hintText,
    this.hasError = false,
    this.valueChanged,
    this.onClear,
    this.required,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _enable = true;

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      autofocus: widget.autofocus,
      obscureText: _enable,
      focusNode: widget.focusNode,
      hintText: widget.hintText,
      hasError: widget.hasError,
      valueChanged: widget.valueChanged,
      onClear: widget.onClear,
      required: widget.required,
      rightIcon: InkWell(
        onTap: () {
          setState(() {
            _enable = !_enable;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: LoadImage(
            url: _enable ? Assets.iconsEyeOn : Assets.iconsEyeOff,
            colors: theme.color.b20,
          ),
        ),
      ),
    );
  }
}
