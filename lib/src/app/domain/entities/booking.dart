class Booking {
  const Booking({
    required this.id,
    required this.customerUsername,
    required this.customerName,
    required this.customerPhone,
    required this.pitchId,
    required this.pitchName,
    required this.venueId,
    required this.venueName,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.note,
  });

  final String id;
  final String customerUsername;
  final String customerName;
  final String customerPhone;
  final String pitchId;
  final String pitchName;
  final String venueId;
  final String venueName;
  final DateTime startTime;
  final DateTime endTime;
  final num totalPrice;
  final String status;
  final String note;
}
