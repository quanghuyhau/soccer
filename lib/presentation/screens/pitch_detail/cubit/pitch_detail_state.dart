part of 'pitch_detail_cubit.dart';

abstract class PitchDetailState {}

class PitchDetailInitial extends PitchDetailState {}

class PitchDetailLoading extends PitchDetailState {}

class PitchDetailLoaded extends PitchDetailState {
  final List<PitchPriceResponse> prices;
  final BookingResponse? latestBooking;
  final String? errorMessage;

  PitchDetailLoaded({
    required this.prices,
    this.latestBooking,
    this.errorMessage,
  });

  PitchDetailLoaded copyWith({
    List<PitchPriceResponse>? prices,
    BookingResponse? latestBooking,
    String? errorMessage,
  }) {
    return PitchDetailLoaded(
      prices: prices ?? this.prices,
      latestBooking: latestBooking ?? this.latestBooking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PitchDetailError extends PitchDetailState {
  final String message;
  PitchDetailError(this.message);
}
