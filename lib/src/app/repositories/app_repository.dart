import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_sources/app_data_source.dart';
import 'home_repository.dart';
import 'impl/home_repository_impl.dart';
import 'impl/login_repository_impl.dart';
import 'login_repository.dart';

export 'home_repository.dart';
export 'login_repository.dart';

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
