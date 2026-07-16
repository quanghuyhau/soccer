class BookingRequest {
  BookingRequest({
    required this.pitchId,
    required this.customerName,
    required this.customerPhone,
    required this.startTime,
    required this.endTime,
    this.note,
  });

  final String pitchId;
  final String customerName;
  final String customerPhone;
  final String startTime;
  final String endTime;
  final String? note;

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      pitchId: json['pitchId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pitchId': pitchId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'startTime': startTime,
      'endTime': endTime,
      'note': note,
    };
  }
}

class BookingStatusRequest {
  BookingStatusRequest({
    required this.status,
  });

  final String status;

  factory BookingStatusRequest.fromJson(Map<String, dynamic> json) {
    return BookingStatusRequest(
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
