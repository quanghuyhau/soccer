class CreateVenueRequest {
  const CreateVenueRequest({
    required this.code,
    required this.name,
    required this.description,
    required this.phone,
    required this.address,
    required this.openTime,
    required this.closeTime,
  });

  final String code;
  final String name;
  final String description;
  final String phone;
  final String address;
  final String openTime;
  final String closeTime;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'phone': phone,
      'address': address,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}
