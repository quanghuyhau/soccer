import 'package:injectable/injectable.dart';

import 'package:soccer/data/repositories/base_repository.dart';
import 'package:soccer/data/data_source/services/app_data_source.dart';
import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/repositories/login_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<AuthTokens> login(LoginRequest request) {
    return executeDataSourceRequest(() => _dataSource.login(request));
  }

  @override
  Future<AppUser> register(RegisterRequest request) {
    return executeDataSourceRequest(() => _dataSource.register(request));
  }

  @override
  Future<AppUser> getCurrentUser({String? accessToken}) {
    return executeDataSourceRequest(
      () => _dataSource.getCurrentUser(accessToken: accessToken),
    );
  }
}
