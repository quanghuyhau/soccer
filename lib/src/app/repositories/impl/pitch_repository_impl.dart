import '../../../core/repository/base_repository.dart';
import '../../data_sources/app_data_source.dart';
import '../../models/app_models.dart';
import '../pitch_repository.dart';

class PitchRepositoryImpl extends BaseRepository implements PitchRepository {
  const PitchRepositoryImpl(this._dataSource);

  final PitchDataSource _dataSource;

  @override
  Future<List<Pitch>> getPitches() {
    return guard(_dataSource.getPitches);
  }

  @override
  Future<Pitch> getPitch(String pitchId) {
    return guard(() => _dataSource.getPitch(pitchId));
  }

  @override
  Future<List<Pitch>> getPitchesByVenue(String venueId) {
    return guard(() => _dataSource.getPitchesByVenue(venueId));
  }

  @override
  Future<Pitch> createPitch({
    required String venueId,
    required CreatePitchRequest request,
  }) {
    return guard(
      () => _dataSource.createPitch(venueId: venueId, request: request),
    );
  }

  @override
  Future<Pitch> updatePitch({
    required String pitchId,
    required CreatePitchRequest request,
  }) {
    return guard(
      () => _dataSource.updatePitch(pitchId: pitchId, request: request),
    );
  }

  @override
  Future<void> deletePitch(String pitchId) {
    return guard(() => _dataSource.deletePitch(pitchId));
  }

  @override
  Future<List<PitchPrice>> getPitchPrices(String pitchId) {
    return guard(() => _dataSource.getPitchPrices(pitchId));
  }

  @override
  Future<PitchPrice> createPitchPrice({
    required String pitchId,
    required CreatePitchPriceRequest request,
  }) {
    return guard(
      () => _dataSource.createPitchPrice(pitchId: pitchId, request: request),
    );
  }
}
