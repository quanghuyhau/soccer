import 'package:flutter/material.dart';
import 'package:atm_soundbox/generated/assets.dart';
import 'package:atm_soundbox/presentation/common/load_image/load_image.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    this.title,
    this.child,
    this.actions,
    this.onBack,
    this.leadingWidth,
    this.titleSpacing,
    this.centerTitle = true,
    this.leadingIcon,
    this.leading,
    this.isClose,
    this.onClose,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.height,
  }) : super(key: key);

  final String? title;
  final Widget? child;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final double? leadingWidth;
  final double? titleSpacing;
  final bool centerTitle;
  final String? leadingIcon;
  final Widget? leading;
  final bool? isClose;
  final VoidCallback? onClose;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return AppBar(
      backgroundColor: backgroundColor ?? theme.color.b900,
      centerTitle: centerTitle,
      leading: _buildLeadingWidget(context),
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: child ??
          Text(
            title ?? '',
            style: theme.font.subTitleBold.copyWith(
              color: theme.color.b20,
            ),
          ),
      actions: actions,
    );
  }

  Widget? _buildLeadingWidget(BuildContext context) {
    if (!automaticallyImplyLeading) {
      return null;
    }
    if (leading != null) {
      return leading;
    }
    if (isClose == true) {
      return IconButton(
        icon: LoadImage(
          url: leadingIcon ?? Assets.iconsClose,
          colors: theme.color.b20,
        ),
        onPressed: () {
          onClose?.call();
        },
      );
    }
    return IconButton(
      icon: LoadImage(
        url: leadingIcon ?? Assets.iconsArrowLeft,
        colors: theme.color.b20,
      ),
      onPressed: onBack != null
          ? onBack!
          : () {
              Navigator.maybePop(context);
            },
    );
  }
}
