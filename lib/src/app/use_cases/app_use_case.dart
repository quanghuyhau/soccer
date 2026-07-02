import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/app_repository.dart';
import 'home/get_sample_item_use_case.dart';
import 'login/login_use_case.dart';

export 'home/get_sample_item_use_case.dart';
export 'login/login_use_case.dart';

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
