class Venue {
  const Venue({
    required this.id,
    required this.ownerId,
    required this.code,
    required this.name,
    required this.description,
    required this.phone,
    required this.address,
    required this.openTime,
    required this.closeTime,
    required this.status,
  });

  final String id;
  final String ownerId;
  final String code;
  final String name;
  final String description;
  final String phone;
  final String address;
  final String openTime;
  final String closeTime;
  final String status;
}
