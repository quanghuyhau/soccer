part of 'venues_cubit.dart';

abstract class VenuesState {}

class VenuesInitial extends VenuesState {}

class VenuesLoading extends VenuesState {}

class VenuesLoaded extends VenuesState {
  final List<VenueResponse> venues;
  VenuesLoaded(this.venues);
}

class VenuesError extends VenuesState {
  final String message;
  VenuesError(this.message);
}
