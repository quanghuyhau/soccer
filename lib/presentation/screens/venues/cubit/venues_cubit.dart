import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/response/venue_response.dart';
import 'package:soccer/domain/use_cases/get_venues_usecase.dart';

part 'venues_state.dart';

@injectable
class VenuesCubit extends Cubit<VenuesState> {
  final GetVenuesUseCase _getVenuesUseCase;

  VenuesCubit({
    required GetVenuesUseCase getVenuesUseCase,
  })  : _getVenuesUseCase = getVenuesUseCase,
        super(VenuesInitial());

  Future<void> fetchVenues() async {
    emit(VenuesLoading());
    try {
      final response = await _getVenuesUseCase.execute();
      if (response.success == true && response.result != null) {
        emit(VenuesLoaded(response.result!));
      } else {
        emit(VenuesError(response.message ?? 'Không thể tải danh sách sân'));
      }
    } catch (e) {
      emit(VenuesError('Lỗi kết nối: $e'));
    }
  }
}
