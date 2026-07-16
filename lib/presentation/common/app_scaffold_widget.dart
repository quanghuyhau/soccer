import 'package:flutter/material.dart';
import 'package:soccer/utilities/style/style.dart';

class AppScaffold extends StatelessWidget {
  final Key? keyScaffold;
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final EdgeInsets? bottomNavigationPadding;
  final Color? backgroundColor;
  final Widget? drawer;
  final bool? resizeToAvoidBottomInset;

  const AppScaffold({
    Key? key,
    this.keyScaffold,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
    this.floatingActionButton,
    this.bottomNavigationPadding,
    this.backgroundColor,
    this.drawer,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: keyScaffold,
        appBar: appBar,
        drawer: drawer,
        backgroundColor: backgroundColor ?? theme.color.b900,
        body: body,
        bottomNavigationBar: _buildBottomBar(context),
        floatingActionButton: floatingActionButton,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }

  Widget? _buildBottomBar(BuildContext context) {
    if (bottomNavigationBar == null) {
      return null;
    }

    return Padding(
      padding: bottomNavigationPadding ?? EdgeInsets.zero,
      child: bottomNavigationBar,
    );
  }
}
