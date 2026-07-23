import 'dart:convert';

import 'package:flutter/foundation.dart';

// Parse JSON object ở isolate phụ để socket message lớn không làm khựng UI.
Future<Map<String, dynamic>> decodeJsonObjectInIsolate(String source) {
  return compute(_decodeJsonObject, source);
}

// Parse JSON list ở isolate phụ, dùng khi API/socket trả về nhiều item.
Future<List<Map<String, dynamic>>> decodeJsonObjectListInIsolate(
  String source,
) {
  return compute(_decodeJsonObjectList, source);
}

// Hàm chạy bên isolate: decode string và đảm bảo kết quả là object.
Map<String, dynamic> _decodeJsonObject(String source) {
  final data = jsonDecode(source);

  if (data is Map<String, dynamic>) {
    return data;
  }

  throw const FormatException('JSON is not an object.');
}

// Hàm chạy bên isolate: decode string và đảm bảo kết quả là list object.
List<Map<String, dynamic>> _decodeJsonObjectList(String source) {
  final data = jsonDecode(source);

  if (data is! List<dynamic>) {
    throw const FormatException('JSON is not a list.');
  }

  return data.map((item) {
    if (item is Map<String, dynamic>) {
      return item;
    }

    throw const FormatException('JSON item is not an object.');
  }).toList();
}
