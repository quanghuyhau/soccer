import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:atm_soundbox/generated/assets.dart';
import 'package:atm_soundbox/generated/l10n.dart';
import 'package:atm_soundbox/presentation/common/load_image/load_image.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

class EmptyWidget extends StatelessWidget {
  final String? description;
  final LoadImage? iconWidget;
  final TextStyle? descriptionTextStyle;

  const EmptyWidget({
    Key? key,
    this.description,
    this.iconWidget,
    this.descriptionTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget ??
              Lottie.asset(
                Assets.animNoData,
                width: 120,
                height: 120,
              ),
          const SizedBox(
            height: 24,
          ),
          Text(
            description ?? S.current.no_data,
            textAlign: TextAlign.center,
            style: descriptionTextStyle ??
                theme.font.bodyBold.copyWith(color: theme.color.b20),
          ),
        ],
      ),
    );
  }
}
