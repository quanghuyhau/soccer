class PitchResponse {
  PitchResponse({
    this.id,
    this.venueId,
    this.venueName,
    this.code,
    this.name,
    this.description,
    this.type,
    this.size,
    this.surface,
    this.status,
  });

  final String? id;
  final String? venueId;
  final String? venueName;
  final String? code;
  final String? name;
  final String? description;
  final String? type;
  final String? size;
  final String? surface;
  final String? status;

  factory PitchResponse.fromJson(Map<String, dynamic> json) {
    return PitchResponse(
      id: json['id'] as String?,
      venueId: json['venueId'] as String?,
      venueName: json['venueName'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      size: json['size'] as String?,
      surface: json['surface'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueId': venueId,
      'venueName': venueName,
      'code': code,
      'name': name,
      'description': description,
      'type': type,
      'size': size,
      'surface': surface,
      'status': status,
    };
  }
}
