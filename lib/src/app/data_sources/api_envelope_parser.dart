import '../../core/error/app_exception.dart';
import '../../core/network/backend_error_mapper.dart';

Map<String, dynamic> parseJsonObject(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }

  throw const ParsingException('Response data is not a JSON object.');
}

Map<String, dynamic> parseApiObject(Object? data) {
  final envelope = parseJsonObject(data);
  _checkApiCode(envelope);

  final result = envelope['result'];
  return parseJsonObject(result);
}

List<Map<String, dynamic>> parseApiObjectList(Object? data) {
  final envelope = parseJsonObject(data);
  _checkApiCode(envelope);

  final result = envelope['result'];
  if (result is! List<dynamic>) {
    throw const ParsingException('API result is not a JSON array.');
  }

  return result.map(parseJsonObject).toList();
}

Object? parseApiSuccess(Object? data) {
  final envelope = parseJsonObject(data);
  _checkApiCode(envelope);
  return null;
}

void _checkApiCode(Map<String, dynamic> envelope) {
  final code = envelope['code'];
  final message = envelope['message'];

  if (code is int && code >= 400) {
    throw BackendErrorMapper.fromCode(
      code,
      message: message is String ? message : 'Request failed.',
      httpStatusCode: null,
    );
  }
}
