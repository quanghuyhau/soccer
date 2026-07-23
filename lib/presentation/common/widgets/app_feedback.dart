import 'package:flutter/material.dart';

import 'package:soccer/utilities/utils/app_exception.dart';
import 'package:soccer/presentation/common/base_state.dart';
import 'package:soccer/presentation/common/widgets/app_design.dart';

class AppToast {
  const AppToast._();

  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle,
      color: AppColors.teal,
    );
  }

  static void error(BuildContext context, Object error) {
    _show(
      context,
      message: errorMessage(error),
      icon: Icons.error_outline,
      color: AppColors.coral,
    );
  }

  static void failure(BuildContext context, AppFailure<dynamic> failure) {
    _show(
      context,
      message: failure.message,
      icon: Icons.error_outline,
      color: AppColors.coral,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      color: AppColors.navy,
    );
  }

  static String errorMessage(
    Object error, {
    String fallback = 'Có lỗi xảy ra',
  }) {
    if (error is AppException) {
      return error.message;
    }

    if (error is String && error.isNotEmpty) {
      return error;
    }

    return fallback;
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Đang xử lý...',
  });

  final bool isLoading;
  final Widget child;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.22),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(minWidth: 160),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
