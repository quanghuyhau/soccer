import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/usecase/usecase.dart';
import '../models/app_models.dart';
import '../repositories/app_repository.dart';

final appUseCaseProvider = Provider<AppUseCase>((ref) {
  final repository = ref.watch(appRepositoryProvider);

  return AppUseCase(
    getSampleItem: GetSampleItemUseCase(repository.home),
    login: LoginUseCase(repository.login),
  );
});

class AppUseCase {
  const AppUseCase({required this.getSampleItem, required this.login});

  final GetSampleItemUseCase getSampleItem;
  final LoginUseCase login;
}

class GetSampleItemUseCase implements UseCase<SampleItem, NoParams> {
  const GetSampleItemUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<SampleItem> call(NoParams input) {
    return _repository.getSampleItem();
  }
}

class LoginUseCase implements UseCase<AuthSession, LoginRequest> {
  const LoginUseCase(this._repository);

  final LoginRepository _repository;

  @override
  Future<AuthSession> call(LoginRequest input) {
    return _repository.login(input);
  }
}
