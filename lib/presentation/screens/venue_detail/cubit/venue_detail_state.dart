part of 'venue_detail_cubit.dart';

abstract class VenueDetailState {}

class VenueDetailInitial extends VenueDetailState {}

class VenueDetailLoading extends VenueDetailState {}

class VenueDetailLoaded extends VenueDetailState {
  final List<PitchResponse> pitches;
  VenueDetailLoaded(this.pitches);
}

class VenueDetailError extends VenueDetailState {
  final String message;
  VenueDetailError(this.message);
}
