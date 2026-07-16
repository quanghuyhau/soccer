class VenueResponse {
  VenueResponse({
    this.id,
    this.ownerId,
    this.code,
    this.name,
    this.description,
    this.phone,
    this.address,
    this.openTime,
    this.closeTime,
    this.status,
  });

  final String? id;
  final String? ownerId;
  final String? code;
  final String? name;
  final String? description;
  final String? phone;
  final String? address;
  final String? openTime;
  final String? closeTime;
  final String? status;

  factory VenueResponse.fromJson(Map<String, dynamic> json) {
    return VenueResponse(
      id: json['id'] as String?,
      ownerId: json['ownerId'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'code': code,
      'name': name,
      'description': description,
      'phone': phone,
      'address': address,
      'openTime': openTime,
      'closeTime': closeTime,
      'status': status,
    };
  }
}
