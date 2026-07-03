import '../../../core/repository/base_repository.dart';
import '../../data_sources/app_data_source.dart';
import '../../models/app_models.dart';
import '../auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<AuthTokens> login(LoginRequest request) {
    return guard(() => _dataSource.login(request));
  }

  @override
  Future<AppUser> register(RegisterRequest request) {
    return guard(() => _dataSource.register(request));
  }

  @override
  Future<AppUser> getCurrentUser() {
    return guard(_dataSource.getCurrentUser);
  }
}
