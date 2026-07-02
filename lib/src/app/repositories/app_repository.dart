import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/repository/base_repository.dart';
import '../data_sources/app_data_source.dart';
import '../models/app_models.dart';

final appRepositoryProvider = Provider<AppRepository>((ref) {
  final dataSource = ref.watch(appDataSourceProvider);

  return AppRepository(
    home: HomeRepositoryImpl(dataSource.home),
    login: LoginRepositoryImpl(dataSource.login),
  );
});

class AppRepository {
  const AppRepository({required this.home, required this.login});

  final HomeRepository home;
  final LoginRepository login;
}

abstract interface class HomeRepository {
  Future<SampleItem> getSampleItem();
}

class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeDataSource _dataSource;

  @override
  Future<SampleItem> getSampleItem() {
    return guard(_dataSource.getSampleItem);
  }
}

abstract interface class LoginRepository {
  Future<AuthSession> login(LoginRequest request);
}

class LoginRepositoryImpl extends BaseRepository implements LoginRepository {
  const LoginRepositoryImpl(this._dataSource);

  final LoginDataSource _dataSource;

  @override
  Future<AuthSession> login(LoginRequest request) {
    return guard(() => _dataSource.login(request));
  }
}
