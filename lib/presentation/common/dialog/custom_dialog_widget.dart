import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:soccer/presentation/common/button/app_button.dart';
import 'package:soccer/utilities/style/style.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.activeButton,
    this.child,
    this.childPadding,
    this.cancelButton,
    this.enableBackHardware = true,
    this.messageStyle,
    this.titleStyle,
    this.messageTextAlign = TextAlign.center,
    this.insetPadding,
    this.contentPadding,
    this.bgColor,
    this.hasBlur = false,
  });

  final Widget? icon;
  final String? title;
  final String? message;
  final AppButton? cancelButton;
  final Widget? activeButton;
  final Widget? child;
  final EdgeInsets? childPadding;
  final EdgeInsets? contentPadding;
  final bool enableBackHardware;
  final TextStyle? messageStyle;
  final TextStyle? titleStyle;
  final TextAlign messageTextAlign;
  final EdgeInsets? insetPadding;
  final Color? bgColor;
  final bool hasBlur;

  dialogContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => enableBackHardware,
      child: Container(
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: bgColor ?? theme.color.b700,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: icon != null ? 32 : 24,
            ),
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: icon!,
              ),
            if (title != null && title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  textAlign: TextAlign.center,
                  title!,
                  style: titleStyle ?? theme.font.subTitle.copyWith(
              color: theme.color.b20,
            ),
                ),
              ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  message!,
                  textAlign: messageTextAlign,
                  style: messageStyle ?? theme.font.body.copyWith(
              color: theme.color.b20,
            ),
                ),
              ),
            if (child != null)
              Padding(
                padding:
                    childPadding ?? const EdgeInsets.symmetric(vertical: 16),
                child: child,
              ),
            Row(
              children: [
                if (cancelButton != null) Expanded(child: cancelButton!),
                if (cancelButton != null) const SizedBox(width: 8),
                if (activeButton != null) Expanded(child: activeButton!)
              ],
            ),
            const SizedBox(
              height: 32,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding ??
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      child: dialogContent(context),
    );
    return hasBlur
        ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: dialog,
          )
        : dialog;
  }
}

// Add show only option in order to dismiss current showing dialog
Future showCustomDialog({
  required BuildContext context,
  String? title,
  String? tileActiveButton,
  Widget? child,
  EdgeInsets? childPadding,
  bool barrierDismissible = false,
  bool useRootNavigator = true,
  VoidCallback? onPressActiveButton,
  AppButton? cancelButton,
  Widget? icon,
  String? message,
  bool enableBackHardware = true,
  TextStyle? messageStyle,
  bool showOnly = false,
  EdgeInsets? insetPadding,
  EdgeInsets? contentPadding,
  Color? bgColor,
  bool hasBlur = false,
}) {
  if (!showOnly) {
    return _showCustomDialog(
      context: context,
      title: title,
      tileActiveButton: tileActiveButton,
      child: child,
      childPadding: childPadding,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      onPressActiveButton: onPressActiveButton,
      cancelButton: cancelButton,
      icon: icon,
      message: message,
      enableBackHardware: enableBackHardware,
      messageStyle: messageStyle,
      insetPadding: insetPadding,
      contentPadding: contentPadding,
      bgColor: bgColor,
      hasBlur: hasBlur,
    );
  }

  if (_isDialogShowing) {
    Navigator.pop(context);
  }

  return Future.delayed(const Duration(milliseconds: 50)).then(
    (value) {
      return _showCustomDialog(
        context: context,
        title: title,
        tileActiveButton: tileActiveButton,
        child: child,
        childPadding: childPadding,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        onPressActiveButton: onPressActiveButton,
        cancelButton: cancelButton,
        icon: icon,
        message: message,
        enableBackHardware: enableBackHardware,
        messageStyle: messageStyle,
        hasBlur: hasBlur,
      );
    },
  );
}

bool _isDialogShowing = false;

Future _showCustomDialog({
  required BuildContext context,
  String? title,
  String? tileActiveButton,
  Widget? child,
  EdgeInsets? childPadding,
  bool barrierDismissible = false,
  bool useRootNavigator = true,
  VoidCallback? onPressActiveButton,
  AppButton? cancelButton,
  Widget? icon,
  String? message,
  bool enableBackHardware = true,
  TextStyle? messageStyle,
  EdgeInsets? insetPadding,
  EdgeInsets? contentPadding,
  Color? bgColor,
  bool hasBlur = false,
}) {
  _isDialogShowing = true;
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => enableBackHardware,
        child: CustomDialog(
          title: title,
          icon: icon,
          message: message,
          messageStyle: messageStyle,
          activeButton: tileActiveButton == null || tileActiveButton.isEmpty
              ? null
              : AppButton.primary(
                  title: tileActiveButton,
                  onPress: onPressActiveButton,
                ),
          cancelButton: cancelButton,
          childPadding: childPadding,
          contentPadding: contentPadding,
          insetPadding: insetPadding,
          bgColor: bgColor,
          hasBlur: hasBlur,
          child: child,
        ),
      );
    },
  ).then((value) {
    _isDialogShowing = false;
    return value;
  });
}
