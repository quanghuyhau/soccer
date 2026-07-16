import 'package:flutter/material.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

class AppLoading extends StatelessWidget {
  factory AppLoading.centerLoading({double height = 80}) =>
      AppLoading(height: height);

  const AppLoading({
    Key? key,
    this.height = 24,
    this.color,
  }) : super(key: key);

  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return Center(
      child: SizedBox(
          width: height,
          height: height,
          child: CircularProgressIndicator(
            color: color ?? theme.color.c1,
            backgroundColor: (color ?? theme.color.c1).withOpacity(0.5),
            strokeWidth: 2,
          )),
    );
  }
}
