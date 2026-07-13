import '../error/app_exception.dart';

abstract class BaseRepository {
  const BaseRepository();

  Future<T> executeDataSourceRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on AppException {
      rethrow;
    } catch (error) {
      throw AppException(error.toString());
    }
  }
}
