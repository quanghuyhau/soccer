import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/response/pitch_response.dart';
import 'package:soccer/domain/use_cases/get_pitches_usecase.dart';

part 'venue_detail_state.dart';

@injectable
class VenueDetailCubit extends Cubit<VenueDetailState> {
  final GetPitchesUseCase _getPitchesUseCase;

  VenueDetailCubit({
    required GetPitchesUseCase getPitchesUseCase,
  })  : _getPitchesUseCase = getPitchesUseCase,
        super(VenueDetailInitial());

  Future<void> fetchPitches(String venueId) async {
    emit(VenueDetailLoading());
    try {
      final response = await _getPitchesUseCase.execute(venueId);
      if (response.success == true && response.result != null) {
        emit(VenueDetailLoaded(response.result!));
      } else {
        emit(VenueDetailError(response.message ?? 'Không thể tải danh sách sân'));
      }
    } catch (e) {
      emit(VenueDetailError('Lỗi kết nối: $e'));
    }
  }
}
