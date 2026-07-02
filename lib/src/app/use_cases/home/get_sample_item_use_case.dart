import '../../../core/usecase/usecase.dart';
import '../../models/app_models.dart';
import '../../repositories/home_repository.dart';

class GetSampleItemUseCase implements UseCase<SampleItem, NoParams> {
  const GetSampleItemUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<SampleItem> call(NoParams input) {
    return _repository.getSampleItem();
  }
}
