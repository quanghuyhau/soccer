import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:soccer/data/models/request/login_request.dart';
import 'package:soccer/data/models/request/pitch_price_request.dart';
import 'package:soccer/data/models/request/booking_request.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/venue_response.dart';
import 'package:soccer/data/models/response/pitch_response.dart';
import 'package:soccer/data/models/response/pitch_price_response.dart';
import 'package:soccer/data/models/response/booking_response.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('/auth/login')
  Future<BaseResponse> login(
    @Body() LoginRequest request,
  );

  @GET('/api/venues')
  Future<BaseResponse<List<VenueResponse>>> getVenues();

  @GET('/api/venues/{venueId}/pitches')
  Future<BaseResponse<List<PitchResponse>>> getPitches(
    @Path('venueId') String venueId,
  );

  @GET('/api/pitches/{pitchId}/prices')
  Future<BaseResponse<List<PitchPriceResponse>>> getPitchPrices(
    @Path('pitchId') String pitchId,
  );

  @POST('/api/pitches/{pitchId}/prices')
  Future<BaseResponse<PitchPriceResponse>> createPitchPrice(
    @Path('pitchId') String pitchId,
    @Body() PitchPriceRequest request,
  );

  @PUT('/api/pitch-prices/{priceId}')
  Future<BaseResponse<PitchPriceResponse>> updatePitchPrice(
    @Path('priceId') String priceId,
    @Body() PitchPriceRequest request,
  );

  @DELETE('/api/pitch-prices/{priceId}')
  Future<BaseResponse<dynamic>> deletePitchPrice(
    @Path('priceId') String priceId,
  );

  @POST('/api/bookings')
  Future<BaseResponse<BookingResponse>> createBooking(
    @Body() BookingRequest request,
  );

  @GET('/api/bookings')
  Future<BaseResponse<List<BookingResponse>>> getBookings();

  @GET('/api/bookings/{bookingId}')
  Future<BaseResponse<BookingResponse>> getBookingDetail(
    @Path('bookingId') String bookingId,
  );

  @GET('/api/bookings/me')
  Future<BaseResponse<List<BookingResponse>>> getMyBookings();

  @GET('/api/pitches/{pitchId}/bookings')
  Future<BaseResponse<List<BookingResponse>>> getBookingsByPitch(
    @Path('pitchId') String pitchId,
  );

  @PATCH('/api/bookings/{bookingId}/status')
  Future<BaseResponse<BookingResponse>> updateBookingStatus(
    @Path('bookingId') String bookingId,
    @Body() BookingStatusRequest request,
  );

  @DELETE('/api/bookings/{bookingId}')
  Future<BaseResponse<dynamic>> deleteBooking(
    @Path('bookingId') String bookingId,
  );
}
