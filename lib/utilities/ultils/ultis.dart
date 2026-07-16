import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

void afterBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

final themeStreamController = BehaviorSubject<bool>();
final Stream<bool> themeStream = themeStreamController.asBroadcastStream();

final billStreamController = BehaviorSubject<bool>();
final Stream<bool> billStream = billStreamController.asBroadcastStream();

class Utils {
  static late final String deviceId;
  static late final PackageInfo packageInfo;
  static late final AndroidDeviceInfo androidInfo;
  static late final IosDeviceInfo iosDeviceInfo;
  static const String android = 'Android';
  static const String ios = 'iOS';

  static initSystemInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    }
    if (Platform.isIOS) {
      iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor ?? '';
    }
    packageInfo = await PackageInfo.fromPlatform();
  }

  static get isStoreVersion {
    return Utils.packageInfo.packageName == '';
  }

  static get platform => Platform.isIOS ? ios : android;

  static get deviceName =>
      Platform.isIOS ? iosDeviceInfo.name : androidInfo.model;

  static get appVersion =>
      '${packageInfo.version} (${packageInfo.buildNumber})';

  static get osName => Platform.isIOS
      ? iosDeviceInfo.systemVersion
      : 'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';

}
