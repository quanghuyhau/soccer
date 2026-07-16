import 'package:soccer/presentation/screens/login/login_route.dart';
import 'package:soccer/presentation/screens/venues/venues_route.dart';
import 'package:soccer/presentation/screens/venue_detail/venue_detail_route.dart';
import 'package:soccer/presentation/screens/pitch_detail/pitch_detail_route.dart';
import 'package:soccer/presentation/screens/my_bookings/my_bookings_route.dart';
import 'package:soccer/presentation/screens/owner_prices/owner_prices_route.dart';

generateRoutes() {
  LoginRoute();
  VenuesRoute();
  VenueDetailRoute();
  PitchDetailRoute();
  MyBookingsRoute();
  OwnerPricesRoute();
}
