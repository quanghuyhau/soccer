import '../../../core/repository/base_repository.dart';
import '../../data_sources/app_data_source.dart';
import '../../models/app_models.dart';
import '../login_repository.dart';

class LoginRepositoryImpl extends BaseRepository implements LoginRepository {
  const LoginRepositoryImpl(this._dataSource);

  final LoginDataSource _dataSource;

  @override
  Future<LoginResponse> login(LoginRequest request) {
    return guard(() => _dataSource.login(request));
  }
}
