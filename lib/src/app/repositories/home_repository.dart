import '../models/app_models.dart';

abstract interface class HomeRepository {
  Future<SampleItem> getSampleItem();
}
