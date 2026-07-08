import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_design.dart';
import 'app_feedback.dart';
import 'app_state_views.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.all(16),
    this.useSafeArea = true,
    this.backgroundColor = AppColors.canvas,
    this.background,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.centerTitle = false,
    this.resizeToAvoidBottomInset,
    this.isLoading = false,
    this.loadingMessage = 'Đang xử lý...',
  });

  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final bool useSafeArea;
  final Color backgroundColor;
  final Widget? background;
  final Color? appBarBackgroundColor;
  final Color? appBarForegroundColor;
  final bool centerTitle;
  final bool? resizeToAvoidBottomInset;
  final bool isLoading;
  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: body);

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    final screenBody = Stack(
      fit: StackFit.expand,
      children: [background ?? const BasePitchBackground(), content],
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              leading: leading,
              actions: actions,
              centerTitle: centerTitle,
              backgroundColor: appBarBackgroundColor ?? AppColors.pitchBackdrop,
              foregroundColor: appBarForegroundColor ?? Colors.white,
            ),
      body: AppLoadingOverlay(
        isLoading: isLoading,
        message: loadingMessage,
        child: screenBody,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BasePitchBackground extends StatelessWidget {
  const BasePitchBackground({
    super.key,
    this.compact = false,
    this.bottomColor = AppColors.canvas,
  });

  final bool compact;
  final Color bottomColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: bottomColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _PitchBackgroundPainter(compact: compact),
            ),
          ),
        ],
      ),
    );
  }
}

class _PitchBackgroundPainter extends CustomPainter {
  const _PitchBackgroundPainter({required this.compact});

  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = compact ? AppColors.pitchBackdrop : AppColors.canvas,
    );

    final washPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: compact
            ? const [
                AppColors.pitchBackdrop,
                AppColors.pitchGreen,
                AppColors.pitchClay,
              ]
            : [
                AppColors.mint.withValues(alpha: 0.72),
                AppColors.canvas,
                AppColors.amber.withValues(alpha: 0.18),
              ],
      ).createShader(rect);
    canvas.drawRect(rect, washPaint);

    final linePaint = Paint()
      ..color = compact
          ? Colors.white.withValues(alpha: 0.13)
          : AppColors.pitchGreen.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final fillPaint = Paint()
      ..color = compact
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    final accentPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: compact ? 0.2 : 0.12)
      ..style = PaintingStyle.fill;

    final field = RRect.fromRectAndRadius(
      Rect.fromLTWH(18, 28, size.width - 36, size.height - 56),
      const Radius.circular(8),
    );
    canvas.drawRRect(field, linePaint);

    final center = Offset(size.width * 0.62, size.height * 0.38);
    canvas.drawCircle(center, compact ? 42 : 58, linePaint);
    canvas.drawCircle(center, 4, fillPaint);

    canvas.drawLine(
      Offset(size.width * 0.62, 28),
      Offset(size.width * 0.62, size.height - 28),
      linePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18, size.height * 0.22, 76, size.height * 0.26),
        const Radius.circular(8),
      ),
      linePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width - 94,
          size.height * 0.58,
          76,
          size.height * 0.26,
        ),
        const Radius.circular(8),
      ),
      linePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.24),
      54,
      accentPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.18),
      34,
      Paint()
        ..color = compact
            ? AppColors.mint.withValues(alpha: 0.16)
            : Colors.white.withValues(alpha: 0.5),
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.54),
      78,
      Paint()
        ..color = compact
            ? Colors.black.withValues(alpha: 0.08)
            : AppColors.pitchGreen.withValues(alpha: 0.05),
    );
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.78),
      92,
      Paint()
        ..color = compact
            ? AppColors.pitchBackdrop.withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.38),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BaseScrollScreen extends StatelessWidget {
  const BaseScrollScreen({
    super.key,
    this.title,
    required this.children,
    this.actions,
    this.onRefresh,
    this.padding = const EdgeInsets.all(16),
    this.bottomNavigationBar,
    this.background,
    this.isLoading = false,
    this.loadingMessage = 'Đang xử lý...',
  });

  final String? title;
  final List<Widget> children;
  final List<Widget>? actions;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry padding;
  final Widget? bottomNavigationBar;
  final Widget? background;
  final bool isLoading;
  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    Widget list = ListView(padding: padding, children: children);

    if (onRefresh != null) {
      list = RefreshIndicator(onRefresh: onRefresh!, child: list);
    }

    return BaseScreen(
      title: title,
      actions: actions,
      padding: EdgeInsets.zero,
      bottomNavigationBar: bottomNavigationBar,
      background: background,
      isLoading: isLoading,
      loadingMessage: loadingMessage,
      body: list,
    );
  }
}

class BaseAsyncScreen<T> extends StatelessWidget {
  const BaseAsyncScreen({
    super.key,
    this.title,
    required this.value,
    required this.data,
    this.actions,
    this.onRetry,
    this.onRefresh,
    this.loading,
    this.errorBuilder,
    this.background,
  });

  final String? title;
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final List<Widget>? actions;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;
  final Widget? loading;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: title,
      actions: actions,
      padding: EdgeInsets.zero,
      background: background,
      body: value.when(
        data: (result) {
          final child = data(result);
          if (onRefresh == null) {
            return child;
          }

          return RefreshIndicator(onRefresh: onRefresh!, child: child);
        },
        error: (error, stackTrace) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child:
                errorBuilder?.call(error, stackTrace) ??
                AppErrorView(message: error.toString(), onRetry: onRetry),
          );
        },
        loading: () => loading ?? const AppLoadingView(),
      ),
    );
  }
}
