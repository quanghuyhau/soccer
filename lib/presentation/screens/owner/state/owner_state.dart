import 'package:soccer/domain/entities/app_models.dart';

class OwnerDashboardData {
  const OwnerDashboardData({required this.venues, required this.bookings});

  final List<Venue> venues;
  final List<Booking> bookings;
}
