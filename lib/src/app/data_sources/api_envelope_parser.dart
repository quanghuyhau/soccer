import '../../core/error/app_exception.dart';
import '../../core/network/backend_error_mapper.dart';

Map<String, dynamic> parseJsonObject(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }

  throw const ParsingException('Response data is not a JSON object.');
}

Map<String, dynamic> readResultObject(Map<String, dynamic> envelope) {
  _throwIfApiCodeFailed(envelope);

  final result = envelope['result'];
  if (result is Map<String, dynamic>) {
    return result;
  }

  throw const ParsingException('API result is not a JSON object.');
}

List<dynamic> readResultList(Map<String, dynamic> envelope) {
  _throwIfApiCodeFailed(envelope);

  final result = envelope['result'];
  if (result is List<dynamic>) {
    return result;
  }

  throw const ParsingException('API result is not a JSON array.');
}

void ensureSuccessfulEnvelope(Map<String, dynamic> envelope) {
  _throwIfApiCodeFailed(envelope);
}

void _throwIfApiCodeFailed(Map<String, dynamic> envelope) {
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
