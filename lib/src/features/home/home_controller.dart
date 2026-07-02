import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../app/use_cases/app_use_case.dart';
import '../../core/usecase/usecase.dart';

final homeControllerProvider = FutureProvider.autoDispose<SampleItem>((
  ref,
) async {
  final useCase = ref.watch(appUseCaseProvider);
  return useCase.getSampleItem(const NoParams());
});
