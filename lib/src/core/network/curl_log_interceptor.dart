import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CurlLogInterceptor extends Interceptor {
  const CurlLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(_buildCurl(options), wrapWidth: 1024);
    }

    handler.next(options);
  }

  String _buildCurl(RequestOptions options) {
    final buffer = StringBuffer('curl -X ${options.method}');

    options.headers.forEach((key, value) {
      if (value == null) {
        return;
      }

      buffer.write(' -H ${_quote('$key: $value')}');
    });

    final data = options.data;
    if (data != null) {
      buffer.write(' --data-raw ${_quote(_encodeData(data))}');
    }

    buffer.write(' ${_quote(options.uri.toString())}');
    return buffer.toString();
  }

  String _encodeData(Object data) {
    if (data is FormData) {
      return data.fields
          .map((field) => '${field.key}=${field.value}')
          .join('&');
    }

    if (data is String) {
      return data;
    }

    return jsonEncode(data);
  }

  String _quote(String value) {
    return "'${value.replaceAll("'", r"'\''")}'";
  }
}
