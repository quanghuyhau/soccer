import 'package:flutter/material.dart';
import 'package:soccer/utilities/style/style.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double radius;
  final Decoration? decoration;
  final List<BoxShadow>? boxShadow;

  const CardContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.radius = 8,
    this.decoration,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      padding: padding ?? const EdgeInsets.all(8),
      decoration: decoration ??
          BoxDecoration(
            color: color ?? theme.color.b900,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: boxShadow ??
                const [
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
      child: child,
    );
  }
}
