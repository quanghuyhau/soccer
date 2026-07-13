import 'package:flutter/material.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

BuildContext? get appRootContext => appNavigatorKey.currentContext;
