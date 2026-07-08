import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
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
    loginUseCase: LoginUseCase(repository.auth),
    registerUseCase: RegisterUseCase(repository.auth),
    getCurrentUserUseCase: GetCurrentUserUseCase(repository.auth),
    getVenuesUseCase: GetVenuesUseCase(repository.venues),
    getVenueDetailUseCase: GetVenueDetailUseCase(
      venueRepository: repository.venues,
      pitchRepository: repository.pitches,
    ),
    getVenuesByOwnerUseCase: GetVenuesByOwnerUseCase(repository.venues),
    createVenueUseCase: CreateVenueUseCase(repository.venues),
    updateVenueUseCase: UpdateVenueUseCase(repository.venues),
    deleteVenueUseCase: DeleteVenueUseCase(repository.venues),
    createPitchUseCase: CreatePitchUseCase(repository.pitches),
    updatePitchUseCase: UpdatePitchUseCase(repository.pitches),
    deletePitchUseCase: DeletePitchUseCase(repository.pitches),
    getPitchPricesUseCase: GetPitchPricesUseCase(repository.pitches),
    createPitchPriceUseCase: CreatePitchPriceUseCase(repository.pitches),
    updatePitchPriceUseCase: UpdatePitchPriceUseCase(repository.pitches),
    deletePitchPriceUseCase: DeletePitchPriceUseCase(repository.pitches),
    createBookingUseCase: CreateBookingUseCase(repository.bookings),
    getMyBookingsUseCase: GetMyBookingsUseCase(repository.bookings),
    getAllBookingsUseCase: GetAllBookingsUseCase(repository.bookings),
    updateBookingStatusUseCase: UpdateBookingStatusUseCase(repository.bookings),
  );
});

class AppUseCase {
  const AppUseCase({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetVenuesUseCase getVenuesUseCase,
    required GetVenueDetailUseCase getVenueDetailUseCase,
    required GetVenuesByOwnerUseCase getVenuesByOwnerUseCase,
    required CreateVenueUseCase createVenueUseCase,
    required UpdateVenueUseCase updateVenueUseCase,
    required DeleteVenueUseCase deleteVenueUseCase,
    required CreatePitchUseCase createPitchUseCase,
    required UpdatePitchUseCase updatePitchUseCase,
    required DeletePitchUseCase deletePitchUseCase,
    required GetPitchPricesUseCase getPitchPricesUseCase,
    required CreatePitchPriceUseCase createPitchPriceUseCase,
    required UpdatePitchPriceUseCase updatePitchPriceUseCase,
    required DeletePitchPriceUseCase deletePitchPriceUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required GetMyBookingsUseCase getMyBookingsUseCase,
    required GetAllBookingsUseCase getAllBookingsUseCase,
    required UpdateBookingStatusUseCase updateBookingStatusUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _getVenuesUseCase = getVenuesUseCase,
       _getVenueDetailUseCase = getVenueDetailUseCase,
       _getVenuesByOwnerUseCase = getVenuesByOwnerUseCase,
       _createVenueUseCase = createVenueUseCase,
       _updateVenueUseCase = updateVenueUseCase,
       _deleteVenueUseCase = deleteVenueUseCase,
       _createPitchUseCase = createPitchUseCase,
       _updatePitchUseCase = updatePitchUseCase,
       _deletePitchUseCase = deletePitchUseCase,
       _getPitchPricesUseCase = getPitchPricesUseCase,
       _createPitchPriceUseCase = createPitchPriceUseCase,
       _updatePitchPriceUseCase = updatePitchPriceUseCase,
       _deletePitchPriceUseCase = deletePitchPriceUseCase,
       _createBookingUseCase = createBookingUseCase,
       _getMyBookingsUseCase = getMyBookingsUseCase,
       _getAllBookingsUseCase = getAllBookingsUseCase,
       _updateBookingStatusUseCase = updateBookingStatusUseCase;

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetVenuesUseCase _getVenuesUseCase;
  final GetVenueDetailUseCase _getVenueDetailUseCase;
  final GetVenuesByOwnerUseCase _getVenuesByOwnerUseCase;
  final CreateVenueUseCase _createVenueUseCase;
  final UpdateVenueUseCase _updateVenueUseCase;
  final DeleteVenueUseCase _deleteVenueUseCase;
  final CreatePitchUseCase _createPitchUseCase;
  final UpdatePitchUseCase _updatePitchUseCase;
  final DeletePitchUseCase _deletePitchUseCase;
  final GetPitchPricesUseCase _getPitchPricesUseCase;
  final CreatePitchPriceUseCase _createPitchPriceUseCase;
  final UpdatePitchPriceUseCase _updatePitchPriceUseCase;
  final DeletePitchPriceUseCase _deletePitchPriceUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final GetMyBookingsUseCase _getMyBookingsUseCase;
  final GetAllBookingsUseCase _getAllBookingsUseCase;
  final UpdateBookingStatusUseCase _updateBookingStatusUseCase;

  Future<AuthSessionData> login(LoginRequest request) {
    return _loginUseCase.login(request);
  }

  Future<AppUser> register(RegisterRequest request) {
    return _registerUseCase.register(request);
  }

  Future<AppUser> getCurrentUser({String? accessToken}) {
    return _getCurrentUserUseCase.getCurrentUser(accessToken: accessToken);
  }

  Future<List<Venue>> getVenues() {
    return _getVenuesUseCase.getVenues();
  }

  Future<VenueDetailData> getVenueDetail(String venueId) {
    return _getVenueDetailUseCase.getVenueDetail(venueId);
  }

  Future<List<Venue>> getVenuesByOwner(String ownerId) {
    return _getVenuesByOwnerUseCase.getVenuesByOwner(ownerId);
  }

  Future<Venue> createVenue(CreateVenueRequest request) {
    return _createVenueUseCase.createVenue(request);
  }

  Future<Venue> updateVenue(UpdateVenueParams params) {
    return _updateVenueUseCase.updateVenue(params);
  }

  Future<void> deleteVenue(String venueId) {
    return _deleteVenueUseCase.deleteVenue(venueId);
  }

  Future<Pitch> createPitch(CreatePitchParams params) {
    return _createPitchUseCase.createPitch(params);
  }

  Future<Pitch> updatePitch(UpdatePitchParams params) {
    return _updatePitchUseCase.updatePitch(params);
  }

  Future<void> deletePitch(String pitchId) {
    return _deletePitchUseCase.deletePitch(pitchId);
  }

  Future<List<PitchPrice>> getPitchPrices(String pitchId) {
    return _getPitchPricesUseCase.getPitchPrices(pitchId);
  }

  Future<PitchPrice> createPitchPrice(CreatePitchPriceParams params) {
    return _createPitchPriceUseCase.createPitchPrice(params);
  }

  Future<PitchPrice> updatePitchPrice(UpdatePitchPriceParams params) {
    return _updatePitchPriceUseCase.updatePitchPrice(params);
  }

  Future<void> deletePitchPrice(String priceId) {
    return _deletePitchPriceUseCase.deletePitchPrice(priceId);
  }

  Future<Booking> createBooking(CreateBookingRequest request) {
    return _createBookingUseCase.createBooking(request);
  }

  Future<List<Booking>> getMyBookings() {
    return _getMyBookingsUseCase.getMyBookings();
  }

  Future<List<Booking>> getAllBookings() {
    return _getAllBookingsUseCase.getAllBookings();
  }

  Future<Booking> updateBookingStatus(UpdateBookingStatusParams params) {
    return _updateBookingStatusUseCase.updateBookingStatus(params);
  }
}
