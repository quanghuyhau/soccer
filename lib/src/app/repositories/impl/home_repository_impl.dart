import '../../../core/repository/base_repository.dart';
import '../../data_sources/app_data_source.dart';
import '../../models/app_models.dart';
import '../home_repository.dart';

class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeDataSource _dataSource;

  @override
  Future<SampleItem> getSampleItem() {
    return guard(_dataSource.getSampleItem);
  }
}
