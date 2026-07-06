import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/app_repository.dart';
import 'auth/get_current_user_use_case.dart';
import 'auth/login_use_case.dart';
import 'auth/register_use_case.dart';
import 'bookings/create_booking_use_case.dart';
import 'bookings/get_all_bookings_use_case.dart';
import 'bookings/get_my_bookings_use_case.dart';
import 'bookings/update_booking_status_use_case.dart';
import 'venues/create_pitch_price_use_case.dart';
import 'venues/create_pitch_use_case.dart';
import 'venues/create_venue_use_case.dart';
import 'venues/delete_pitch_price_use_case.dart';
import 'venues/delete_pitch_use_case.dart';
import 'venues/delete_venue_use_case.dart';
import 'venues/get_pitch_prices_use_case.dart';
import 'venues/get_venue_detail_use_case.dart';
import 'venues/get_venues_use_case.dart';
import 'venues/get_venues_by_owner_use_case.dart';
import 'venues/update_pitch_price_use_case.dart';
import 'venues/update_pitch_use_case.dart';
import 'venues/update_venue_use_case.dart';

export 'auth/get_current_user_use_case.dart';
export 'auth/login_use_case.dart';
export 'auth/register_use_case.dart';
export 'bookings/create_booking_use_case.dart';
export 'bookings/get_all_bookings_use_case.dart';
export 'bookings/get_my_bookings_use_case.dart';
export 'bookings/update_booking_status_use_case.dart';
export 'venues/create_pitch_price_use_case.dart';
export 'venues/create_pitch_use_case.dart';
export 'venues/create_venue_use_case.dart';
export 'venues/delete_pitch_price_use_case.dart';
export 'venues/delete_pitch_use_case.dart';
export 'venues/delete_venue_use_case.dart';
export 'venues/get_pitch_prices_use_case.dart';
export 'venues/get_venue_detail_use_case.dart';
export 'venues/get_venues_use_case.dart';
export 'venues/get_venues_by_owner_use_case.dart';
export 'venues/update_pitch_price_use_case.dart';
export 'venues/update_pitch_use_case.dart';
export 'venues/update_venue_use_case.dart';

final appUseCaseProvider = Provider<AppUseCase>((ref) {
  final repository = ref.watch(appRepositoryProvider);

  return AppUseCase(
    login: LoginUseCase(repository.auth),
    register: RegisterUseCase(repository.auth),
    getCurrentUser: GetCurrentUserUseCase(repository.auth),
    getVenues: GetVenuesUseCase(repository.venues),
    getVenueDetail: GetVenueDetailUseCase(
      venueRepository: repository.venues,
      pitchRepository: repository.pitches,
    ),
    getVenuesByOwner: GetVenuesByOwnerUseCase(repository.venues),
    createVenue: CreateVenueUseCase(repository.venues),
    updateVenue: UpdateVenueUseCase(repository.venues),
    deleteVenue: DeleteVenueUseCase(repository.venues),
    createPitch: CreatePitchUseCase(repository.pitches),
    updatePitch: UpdatePitchUseCase(repository.pitches),
    deletePitch: DeletePitchUseCase(repository.pitches),
    getPitchPrices: GetPitchPricesUseCase(repository.pitches),
    createPitchPrice: CreatePitchPriceUseCase(repository.pitches),
    updatePitchPrice: UpdatePitchPriceUseCase(repository.pitches),
    deletePitchPrice: DeletePitchPriceUseCase(repository.pitches),
    createBooking: CreateBookingUseCase(repository.bookings),
    getMyBookings: GetMyBookingsUseCase(repository.bookings),
    getAllBookings: GetAllBookingsUseCase(repository.bookings),
    updateBookingStatus: UpdateBookingStatusUseCase(repository.bookings),
  );
});

class AppUseCase {
  const AppUseCase({
    required this.login,
    required this.register,
    required this.getCurrentUser,
    required this.getVenues,
    required this.getVenueDetail,
    required this.getVenuesByOwner,
    required this.createVenue,
    required this.updateVenue,
    required this.deleteVenue,
    required this.createPitch,
    required this.updatePitch,
    required this.deletePitch,
    required this.getPitchPrices,
    required this.createPitchPrice,
    required this.updatePitchPrice,
    required this.deletePitchPrice,
    required this.createBooking,
    required this.getMyBookings,
    required this.getAllBookings,
    required this.updateBookingStatus,
  });

  final LoginUseCase login;
  final RegisterUseCase register;
  final GetCurrentUserUseCase getCurrentUser;
  final GetVenuesUseCase getVenues;
  final GetVenueDetailUseCase getVenueDetail;
  final GetVenuesByOwnerUseCase getVenuesByOwner;
  final CreateVenueUseCase createVenue;
  final UpdateVenueUseCase updateVenue;
  final DeleteVenueUseCase deleteVenue;
  final CreatePitchUseCase createPitch;
  final UpdatePitchUseCase updatePitch;
  final DeletePitchUseCase deletePitch;
  final GetPitchPricesUseCase getPitchPrices;
  final CreatePitchPriceUseCase createPitchPrice;
  final UpdatePitchPriceUseCase updatePitchPrice;
  final DeletePitchPriceUseCase deletePitchPrice;
  final CreateBookingUseCase createBooking;
  final GetMyBookingsUseCase getMyBookings;
  final GetAllBookingsUseCase getAllBookings;
  final UpdateBookingStatusUseCase updateBookingStatus;
}
