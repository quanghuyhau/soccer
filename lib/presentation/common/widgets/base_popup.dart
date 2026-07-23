import 'package:flutter/material.dart';

import 'package:soccer/utilities/routes/app_navigator.dart';
import 'package:soccer/presentation/common/base_state.dart';
import 'package:soccer/presentation/common/widgets/app_button.dart';
import 'package:soccer/presentation/common/widgets/app_design.dart';

enum AppPopupType { success, error, warning, info }

class BasePopup {
  const BasePopup._();

  static Future<void> showError(
    String message, {
    BuildContext? context,
    String title = 'Không thành công',
    String primaryText = 'Đóng',
    bool showClose = true,
    VoidCallback? onPrimary,
    VoidCallback? onClose,
  }) {
    return show(
      context: context,
      title: title,
      description: message,
      type: AppPopupType.error,
      primaryText: primaryText,
      showClose: showClose,
      onPrimary: onPrimary,
      onClose: onClose,
    );
  }

  static Future<void> showSuccess(
    String message, {
    BuildContext? context,
    String title = 'Thành công',
    String primaryText = 'Đóng',
    bool showClose = true,
    VoidCallback? onPrimary,
    VoidCallback? onClose,
  }) {
    return show(
      context: context,
      title: title,
      description: message,
      type: AppPopupType.success,
      primaryText: primaryText,
      showClose: showClose,
      onPrimary: onPrimary,
      onClose: onClose,
    );
  }

  static Future<void> showFailure(
    AppFailure<dynamic> failure, {
    BuildContext? context,
    String? title,
    String primaryText = 'Đóng',
    bool showClose = true,
    VoidCallback? onPrimary,
    VoidCallback? onClose,
  }) {
    return showError(
      failure.message,
      context: context,
      title: title ?? titleOfFailure(failure),
      primaryText: primaryText,
      showClose: showClose,
      onPrimary: onPrimary,
      onClose: onClose,
    );
  }

  static Future<void> show({
    BuildContext? context,
    required String title,
    String? description,
    AppPopupType type = AppPopupType.info,
    Widget? icon,
    String primaryText = 'Đóng',
    String? secondaryText,
    bool showClose = true,
    bool barrierDismissible = false,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    VoidCallback? onClose,
  }) {
    final targetContext = context ?? appRootContext;
    if (targetContext == null) {
      return Future<void>.value();
    }

    return showDialog<void>(
      context: targetContext,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: icon ?? _PopupIcon(type: type)),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(dialogContext).textTheme.titleMedium
                          ?.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: Theme.of(dialogContext).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.muted, height: 1.35),
                      ),
                    ],
                    const SizedBox(height: 18),
                    AppButton.primary(
                      label: primaryText,
                      isExpanded: true,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onPrimary?.call();
                      },
                    ),
                    if (secondaryText != null) ...[
                      const SizedBox(height: 8),
                      AppButton.text(
                        label: secondaryText,
                        isExpanded: true,
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          onSecondary?.call();
                        },
                      ),
                    ],
                  ],
                ),
              ),
              if (showClose)
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton(
                    tooltip: 'Đóng',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onClose?.call();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static String titleOfFailure(AppFailure<dynamic> failure) {
    return switch (failure.backendCode ?? failure.statusCode) {
      400 => 'Thông tin chưa hợp lệ',
      401 => 'Chưa xác thực',
      403 => 'Không có quyền',
      404 => 'Không tìm thấy dữ liệu',
      409 => 'Dữ liệu bị trùng',
      422 => 'Vui lòng kiểm tra lại',
      500 || 9999 => 'Lỗi hệ thống',
      _ => 'Không thành công',
    };
  }
}

class _PopupIcon extends StatelessWidget {
  const _PopupIcon({required this.type});

  final AppPopupType type;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      AppPopupType.success => (Icons.check_circle, AppColors.teal),
      AppPopupType.error => (Icons.cancel, AppColors.coral),
      AppPopupType.warning => (Icons.warning_amber_rounded, AppColors.amber),
      AppPopupType.info => (Icons.info, AppColors.navy),
    };

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Icon(icon, size: 42, color: color),
    );
  }
}
