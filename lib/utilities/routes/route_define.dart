import 'package:flutter/material.dart';

final List<RouteDefine> _routes = [];
final List<String> _routeIds = [];

abstract class RouteDefine {
  Path initRoute(dynamic arguments);

  String get routeName;

  static List<String> get routeIds => _routeIds;

  RouteDefine() {
    _routes.add(this);
    _routeIds.add(routeName);
  }
}

class Path {
  WidgetBuilder builder;

  Path({required this.builder});
}

MaterialPageRoute? manifest(
  Function generateRoute,
  RouteSettings settings,
) {
  final Map<String?, WidgetBuilder?> routeBuilders = <String, WidgetBuilder>{};

  generateRoute();
  for (int i = 0; i < _routeIds.length; i++) {
    final path = _routes[i].initRoute(
      settings.arguments,
    );

    routeBuilders[_routeIds[i]] = path.builder;
  }
  final Widget Function(BuildContext context)? routeBuilder =
      routeBuilders[settings.name ?? ''];

  bool isAllowSwipeBack = true;
  if (settings.arguments is Map &&
      (settings.arguments as Map)['is_allow_swipe_back'] != null) {
    isAllowSwipeBack = (settings.arguments as Map)['is_allow_swipe_back'];
  }

  return !isAllowSwipeBack
      ? CustomMaterialPageRouteDisableBack(
          builder: (context) => routeBuilder!(context),
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
        )
      : CustomMaterialPageRoute(
          builder: (context) => routeBuilder!(context),
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
        );
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class CustomMaterialPageRouteDisableBack extends MaterialPageRoute {
  @override
  @protected
  bool get hasScopedWillPopCallback {
    return true;
  }

  CustomMaterialPageRouteDisableBack({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}
