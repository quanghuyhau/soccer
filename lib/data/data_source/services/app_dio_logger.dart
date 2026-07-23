import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:soccer/data/data_source/services/network_log_store.dart';

class AppDioLogger extends Interceptor {
  AppDioLogger({this.enabled = true, NetworkLogStore? logStore})
    : _logStore = logStore ?? NetworkLogStore.instance;

  bool enabled;
  final NetworkLogStore _logStore;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      _write(
        _block('API REQUEST', [
          '${options.method} ${options.uri}',
          if (options.queryParameters.isNotEmpty)
            'Query: ${_pretty(options.queryParameters)}',
          'Headers: ${_pretty(_maskedHeaders(options.headers))}',
          if (options.data != null) 'Body: ${_pretty(options.data)}',
        ]),
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (enabled) {
      _write(
        _block('API RESPONSE', [
          '${response.requestOptions.method} ${response.requestOptions.uri}',
          'Status: ${response.statusCode} ${response.statusMessage ?? ''}'
              .trim(),
          if (response.data != null) 'Body: ${_pretty(response.data)}',
        ]),
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (enabled) {
      _write(
        _block('API ERROR', [
          '${err.requestOptions.method} ${err.requestOptions.uri}',
          'Type: ${err.type.name}',
          if (response?.statusCode != null)
            'Status: ${response!.statusCode} ${response.statusMessage ?? ''}'
                .trim(),
          if (err.message != null) 'Message: ${err.message}',
          if (response?.data != null) 'Body: ${_pretty(response!.data)}',
        ]),
      );
    }

    handler.next(err);
  }

  void _write(String message) {
    debugPrint(message);
    _logStore.add(message);
  }

  String _block(String title, List<String> lines) {
    return [
      '┌── $title ──',
      for (final line in lines) ..._splitMultiline(line),
      '└────────────────────────────',
    ].join('\n');
  }

  List<String> _splitMultiline(String text) {
    return text.split('\n').map((line) => '│ $line').toList();
  }

  Map<String, dynamic> _maskedHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      if (key.toLowerCase() == 'authorization' && value is String) {
        return MapEntry(key, _maskBearerToken(value));
      }

      return MapEntry(key, value);
    });
  }

  String _maskBearerToken(String value) {
    const prefix = 'Bearer ';
    if (!value.startsWith(prefix)) {
      return '***';
    }

    final token = value.substring(prefix.length);
    if (token.length <= 12) {
      return '$prefix***';
    }

    return '$prefix${token.substring(0, 8)}...${token.substring(token.length - 4)}';
  }

  String _pretty(Object? value) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(value);
    } catch (_) {
      return value.toString();
    }
  }
}
