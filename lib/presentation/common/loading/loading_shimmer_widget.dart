import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

class AppLoadingShimmer extends StatelessWidget {
  const AppLoadingShimmer({
    Key? key,
    this.height = 24,
    this.width = 120,
    this.enable = true,
    this.color,
    this.background,
    this.radius = 8,
    this.period,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final Color? color;
  final Color? background;
  final double? height;
  final double? width;
  final bool enable;
  final double radius;
  final Duration? period;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return Shimmer(
      enabled: enable,
      period: period ?? const Duration(milliseconds: 600),
      gradient: LinearGradient(
        colors: [
          background ?? theme.color.b800,
          color ?? theme.color.b100.withOpacity(0.2),
          background ?? theme.color.b800,
        ],
        stops: const [
          0.1,
          0.3,
          0.4,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.mirror,
      ),
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: theme.color.b800,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 12,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
      ),
    );
  }
}
