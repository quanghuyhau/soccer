part of '../style.dart';

void setStyleDefault() {
  bool isDark = brightness == Brightness.dark;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: isDark ? Colors.black : Colors.white,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
  ));
}

void setStyleDarkMode() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
}

_NIXOThemeColor _darkThemeData = _NIXODarkTheme();
_NIXOThemeColor _lightThemeData = _NIXOLightTheme();

class _NIXOThemeData {
  _NIXOThemeColor color = _lightThemeData;
  _NIXOThemeFont font = _NIXOThemeFont();

  /// Receiver theme mode updated
  registerNotifyUpdated(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeManager>();

  _update({_NIXOThemeColor? color, _NIXOThemeFont? font}) {
    if (color != null) {
      this.color = color;
    }
    if (font != null) {
      this.font = font;
    }
  }
}

Brightness get brightness => ThemeManager._brightness;

_NIXOThemeData get theme => ThemeManager._current;

/// Support change themes dark and light mode
@immutable
class ThemeManager extends InheritedWidget {
  static Brightness _brightness = Brightness.light;
  static final _NIXOThemeData _themeData = _NIXOThemeData();
  final int timeStamp;

  const ThemeManager({
    Key? key,
    required Widget child,
    required this.timeStamp,
  }) : super(key: key, child: child);

  static updateThemeMode(bool isDarkMode) {
    Responsive.update();
    _brightness = isDarkMode ? Brightness.dark : Brightness.light;
    setStyleDefault();
    final color =
        (_brightness == Brightness.dark) ? _darkThemeData : _lightThemeData;
    _themeData._update(color: color);
  }

  static _NIXOThemeData get _current => _themeData;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return this != oldWidget;
  }
}
