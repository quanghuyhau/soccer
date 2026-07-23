class AppEndpoints {
  const AppEndpoints._();

  static const authLogin = '/api/auth/login';
  static const authRegister = '/api/auth/register';
  static const authRefreshToken = '/api/auth/refresh-token';
  static const currentUser = '/api/users/me';

  static const venues = '/api/venues';
  static String venue(String venueId) => '/api/venues/$venueId';
  static String venuesByOwner(String ownerId) => '/api/venues/owner/$ownerId';

  static const pitches = '/api/pitches';
  static String pitch(String pitchId) => '/api/pitches/$pitchId';
  static String pitchesByVenue(String venueId) =>
      '/api/venues/$venueId/pitches';
  static String pitchBookings(String pitchId) =>
      '/api/pitches/$pitchId/bookings';
  static String pitchPrices(String pitchId) => '/api/pitches/$pitchId/prices';
  static String pitchPrice(String priceId) => '/api/pitch-prices/$priceId';

  static const bookings = '/api/bookings';
  static const myBookings = '/api/bookings/me';

  // Endpoint WebSocket booking; AppConfig sẽ đổi scheme thành ws/wss khi connect.
  static const bookingSocket = '/ws/bookings';
  static String bookingStatus(String bookingId) {
    return '/api/bookings/$bookingId/status';
  }
}
