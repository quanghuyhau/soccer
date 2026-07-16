class PitchPriceRequest {
  PitchPriceRequest({
    required this.startTime,
    required this.endTime,
    required this.pricePerHour,
  });

  final String startTime;
  final String endTime;
  final double pricePerHour;

  factory PitchPriceRequest.fromJson(Map<String, dynamic> json) {
    return PitchPriceRequest(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'pricePerHour': pricePerHour,
    };
  }
}
