class BookingResponse {
  BookingResponse({
    this.id,
    this.customerUsername,
    this.customerName,
    this.customerPhone,
    this.pitchId,
    this.pitchName,
    this.venueId,
    this.venueName,
    this.startTime,
    this.endTime,
    this.totalPrice,
    this.status,
    this.note,
  });

  final String? id;
  final String? customerUsername;
  final String? customerName;
  final String? customerPhone;
  final String? pitchId;
  final String? pitchName;
  final String? venueId;
  final String? venueName;
  final String? startTime;
  final String? endTime;
  final double? totalPrice;
  final String? status;
  final String? note;

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'] as String?,
      customerUsername: json['customerUsername'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      pitchId: json['pitchId'] as String?,
      pitchName: json['pitchName'] as String?,
      venueId: json['venueId'] as String?,
      venueName: json['venueName'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      status: json['status'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerUsername': customerUsername,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'pitchId': pitchId,
      'pitchName': pitchName,
      'venueId': venueId,
      'venueName': venueName,
      'startTime': startTime,
      'endTime': endTime,
      'totalPrice': totalPrice,
      'status': status,
      'note': note,
    };
  }
}
