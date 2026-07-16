class PitchPriceResponse {
  PitchPriceResponse({
    this.id,
    this.pitchId,
    this.pitchName,
    this.startTime,
    this.endTime,
    this.pricePerHour,
  });

  final String? id;
  final String? pitchId;
  final String? pitchName;
  final String? startTime;
  final String? endTime;
  final double? pricePerHour;

  factory PitchPriceResponse.fromJson(Map<String, dynamic> json) {
    return PitchPriceResponse(
      id: json['id'] as String?,
      pitchId: json['pitchId'] as String?,
      pitchName: json['pitchName'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pitchId': pitchId,
      'pitchName': pitchName,
      'startTime': startTime,
      'endTime': endTime,
      'pricePerHour': pricePerHour,
    };
  }
}
