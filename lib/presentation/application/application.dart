import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:atm_soundbox/generated/l10n.dart';
import 'package:atm_soundbox/manifest.dart';
import 'package:atm_soundbox/presentation/screens/login/login_route.dart';
import 'package:atm_soundbox/utilities/routes/route_define.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  String initRoute = LoginRoute().routeName;

  @override
  void initState() {
    super.initState();
    setStyleDefault();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: Get.deviceLocale,
        theme: ThemeData(
          brightness: brightness,
        ),
        fallbackLocale: const Locale('vi'),
        initialRoute: initRoute,
        onGenerateRoute: (settings) => manifest(generateRoutes, settings),
        builder: EasyLoading.init(),
      ),
    );
  }
}
