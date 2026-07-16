import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:atm_soundbox/generated/assets.dart';
import 'package:atm_soundbox/presentation/common/load_image/load_image.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

enum ToastType { Success, Error, Other }

@lazySingleton
class ToastWidget {
  late GlobalKey globalKey;
  FToast fToast = FToast();

  ToastWidget() {
    globalKey = GlobalKey();
    //   fToast.init(globalKey.currentState!.context);
  }

  Widget _toastContent({
    required String message,
    required ToastType toastType,
    Widget? customContent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: theme.color.b300,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToastIconType(toastType),
          const SizedBox(
            width: 8.0,
          ),
          Flexible(
            child: customContent ??
                Text(
                  message,
                  style: theme.font.body.copyWith(
              color: theme.color.b20,
            ),
                ),
          ),
        ],
      ),
    );
  }

  registerContext(BuildContext context) {
    fToast.init(context);
  }

  _showToast(String message, ToastGravity gravity, ToastType toastType,
      {int? duration, Widget? customContent}) {
    //remove duplicate Toast showing
    removeToast();
    fToast.showToast(
      child: _toastContent(
        message: message,
        toastType: toastType,
        customContent: customContent,
      ),
      gravity: gravity,
      toastDuration: Duration(seconds: duration ?? 3),
    );
  }

  Widget _buildToastIconType(ToastType toastType) {
    switch (toastType) {
      case ToastType.Success:
        {
          return LoadImage(
            url: Assets.iconsSuccessOutline,
            colors: theme.color.green500,
          );
        }
      case ToastType.Error:
        {
          return LoadImage(
            url: Assets.iconsWarning,
            colors: theme.color.red500,
          );
        }
      default:
        {
          return const SizedBox();
        }
    }
  }

  showToastTopError({required String message, int? duration}) {
    _showToast(message, ToastGravity.TOP, ToastType.Error, duration: duration);
  }

  showToastTopSuccess(
      {required String message, int? duration, Widget? customContent}) {
    _showToast(message, ToastGravity.TOP, ToastType.Success,
        duration: duration, customContent: customContent);
  }

  showToastCenterSuccess(
      {required String message, int? duration, Widget? customContent}) {
    _showToast(message, ToastGravity.CENTER, ToastType.Success,
        duration: duration, customContent: customContent);
  }

  showToastCenterError(
      {required String message, int? duration, Widget? customContent}) {
    _showToast(message, ToastGravity.CENTER, ToastType.Error,
        duration: duration, customContent: customContent);
  }

  showToastBottomError({required String message, int? duration}) {
    _showToast(message, ToastGravity.BOTTOM, ToastType.Error,
        duration: duration);
  }

  showToastMsg({required String message}) {
    _showToast(message, ToastGravity.CENTER, ToastType.Other);
  }

  // To remove present showing toast
  removeToast() {
    fToast.removeCustomToast();
  }

// To clear the queue

  removeAllQueuedToasts() {
    fToast.removeQueuedCustomToasts();
  }
}
