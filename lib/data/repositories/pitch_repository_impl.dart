import 'package:injectable/injectable.dart';

import 'package:soccer/data/repositories/base_repository.dart';
import 'package:soccer/data/data_source/services/app_data_source.dart';
import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/repositories/pitch_repository.dart';

@LazySingleton(as: PitchRepository)
class PitchRepositoryImpl extends BaseRepository implements PitchRepository {
  const PitchRepositoryImpl(this._dataSource);

  final PitchDataSource _dataSource;

  @override
  Future<List<Pitch>> getPitches() {
    return executeDataSourceRequest(_dataSource.getPitches);
  }

  @override
  Future<Pitch> getPitch(String pitchId) {
    return executeDataSourceRequest(() => _dataSource.getPitch(pitchId));
  }

  @override
  Future<List<Pitch>> getPitchesByVenue(String venueId) {
    return executeDataSourceRequest(
      () => _dataSource.getPitchesByVenue(venueId),
    );
  }

  @override
  Future<Pitch> createPitch({
    required String venueId,
    required CreatePitchRequest request,
  }) {
    return executeDataSourceRequest(
      () => _dataSource.createPitch(venueId: venueId, request: request),
    );
  }

  @override
  Future<Pitch> updatePitch({
    required String pitchId,
    required CreatePitchRequest request,
  }) {
    return executeDataSourceRequest(
      () => _dataSource.updatePitch(pitchId: pitchId, request: request),
    );
  }

  @override
  Future<void> deletePitch(String pitchId) {
    return executeDataSourceRequest(() => _dataSource.deletePitch(pitchId));
  }

  @override
  Future<List<PitchPrice>> getPitchPrices(String pitchId) {
    return executeDataSourceRequest(() => _dataSource.getPitchPrices(pitchId));
  }

  @override
  Future<PitchPrice> createPitchPrice({
    required String pitchId,
    required CreatePitchPriceRequest request,
  }) {
    return executeDataSourceRequest(
      () => _dataSource.createPitchPrice(pitchId: pitchId, request: request),
    );
  }

  @override
  Future<PitchPrice> updatePitchPrice({
    required String priceId,
    required CreatePitchPriceRequest request,
  }) {
    return executeDataSourceRequest(
      () => _dataSource.updatePitchPrice(priceId: priceId, request: request),
    );
  }

  @override
  Future<void> deletePitchPrice(String priceId) {
    return executeDataSourceRequest(
      () => _dataSource.deletePitchPrice(priceId),
    );
  }
}
