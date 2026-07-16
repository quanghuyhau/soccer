import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  // static const String _NAME = 'Logger';
  static final Logger _instance = Logger(
    filter: null,
    printer: PrettyPrinter(
      stackTraceBeginIndex: 1,
      methodCount: 0,
      lineLength: 120,
    ),
    output: null,
  );

  static void setLevel({required String env}) {
    if (kReleaseMode) {
      Logger.level = Level.off;
    }
  }

  static bool canShowLog() {
    return Logger.level != Level.off;
  }

  static void verbose(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _instance.v(
      '$tag: $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _instance.i(
      '$tag: $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void warning(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _instance.w(
      '$tag: $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void config(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _instance.d(
      '$tag: $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void severe(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _instance.e(
      '$tag: $message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
