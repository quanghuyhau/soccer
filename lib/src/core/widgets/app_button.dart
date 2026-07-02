import 'package:flutter/material.dart';

enum AppButtonVariant { primary, outlined, text, destructive }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = false,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.text;

  const AppButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.destructive;

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final child = _ButtonContent(
      label: label,
      icon: icon,
      isLoading: isLoading,
    );
    final enabledOnPressed = isLoading ? null : onPressed;
    final style = _styleOf(context);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: enabledOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: enabledOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: enabledOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.destructive => FilledButton(
        onPressed: enabledOnPressed,
        style: style,
        child: child,
      ),
    };

    if (!isExpanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }

  ButtonStyle? _styleOf(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.onError;
    final backgroundColor = Theme.of(context).colorScheme.error;

    return switch (variant) {
      AppButtonVariant.destructive => FilledButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
      ),
      _ => null,
    };
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
  });

  final String label;
  final Widget? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final progress = SizedBox.square(
      dimension: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: IconTheme.of(context).color,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) progress else if (icon != null) icon!,
        if (isLoading || icon != null) const SizedBox(width: 8),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
