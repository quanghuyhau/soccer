class CreateBookingRequest {
  const CreateBookingRequest({
    required this.pitchId,
    required this.customerName,
    required this.customerPhone,
    required this.startTime,
    required this.endTime,
    required this.note,
  });

  final String pitchId;
  final String customerName;
  final String customerPhone;
  final DateTime startTime;
  final DateTime endTime;
  final String note;

  Map<String, dynamic> toJson() {
    return {
      'pitchId': pitchId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'startTime': _toApiDateTime(startTime),
      'endTime': _toApiDateTime(endTime),
      'note': note,
    };
  }
}

class UpdateBookingStatusRequest {
  const UpdateBookingStatusRequest({required this.status});

  final String status;

  Map<String, dynamic> toJson() {
    return {'status': status};
  }
}

String _toApiDateTime(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');

  return '${local.year}-${two(local.month)}-${two(local.day)}'
      'T${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
}
