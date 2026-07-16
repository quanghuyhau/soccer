import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRouter {
  static pop<T>({T? result}) {
    Get.back(result: result);
  }

  static closeManyRoute({required int times}) {
    Get.close(times);
  }

  static popAndPush({
    required String routeName,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return Get.offAndToNamed(
      routeName,
      arguments: arguments,
      parameters: parameters,
    );
  }

  static Future<dynamic> push({
    required String routeName,
    dynamic arguments,
  }) {
    return Navigator.pushNamed(
      Get.context!,
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushName(String routeName) {
    return Navigator.pushNamed(
      Get.context!,
      routeName,
    );
  }

  static Future<dynamic> pushSpecial(Widget child) {
    return Navigator.push(
      Get.context!,
      MaterialPageRoute(builder: (context) {
        return child;
      }),
    );
  }

  static pushForResult({
    required String routeName,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    return await Get.toNamed(
      routeName,
      arguments: arguments,
      parameters: parameters,
    );
  }

  static pushAndRemoveUntil({
    required String routeName,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    Get.offAllNamed(
      routeName,
      arguments: arguments,
      parameters: parameters,
    );
  }

  static popAndRemoveUntil(String routeName) {
    Get.until((route) => route.settings.name == routeName);
  }
}
