import 'package:flutter/material.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

class AppButton extends StatefulWidget {
  final String title;
  final Color? color;
  final Color? textColor;
  final bool isDisable;
  final VoidCallback? onPress;
  final bool isLoading;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final double? minWidth;
  final Gradient? gradient;

  const AppButton({
    Key? key,
    required this.title,
    this.color,
    this.isDisable = false,
    this.isLoading = false,
    this.fontSize,
    this.onPress,
    this.textColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.height,
    this.minWidth,
    this.gradient,
  }) : super(key: key);

  factory AppButton.primary({
    required String title,
    VoidCallback? onPress,
    bool isLoading = false,
    EdgeInsetsGeometry? contentPadding,
    double? height,
  }) =>
      AppButton(
        title: title,
        onPress: onPress,
        isLoading: isLoading,
        contentPadding: contentPadding,
        height: height,
        textColor: theme.color.pureWhite,
        color: theme.color.c1,
      );

  factory AppButton.secondary({
    required String title,
    VoidCallback? onPress,
    bool isLoading = false,
    EdgeInsetsGeometry? contentPadding,
    double? height,
  }) =>
      AppButton(
        title: title,
        color: theme.color.b400,
        onPress: onPress,
        isLoading: isLoading,
        contentPadding: contentPadding,
        height: height,
      );

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  Widget _loading() {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: theme.color.pureWhite,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    final double height = widget.height ?? 46;
    return Opacity(
      opacity: widget.isDisable ? 0.3 : 1,
      child: Material(
        color: widget.gradient != null
            ? Colors.transparent
            : widget.color ?? theme.color.c1,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: widget.isDisable || widget.isLoading ? null : widget.onPress,
          borderRadius: BorderRadius.circular(8),
          splashFactory: InkRipple.splashFactory,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: widget.minWidth ?? 88,
            ),
            child: Container(
              padding: widget.contentPadding,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: widget.gradient,
              ),
              child: Center(
                  child: widget.isLoading
                      ? _loading()
                      : Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: theme.font.bodyBold.copyWith(
                            color: widget.textColor ?? theme.color.b20,
                            fontSize: widget.fontSize,
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }
}
