class CreatePitchRequest {
  const CreatePitchRequest({
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.size,
    required this.surface,
  });

  final String code;
  final String name;
  final String description;
  final String type;
  final String size;
  final String surface;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'type': type,
      'size': size,
      'surface': surface,
    };
  }
}

class CreatePitchPriceRequest {
  const CreatePitchPriceRequest({
    required this.startTime,
    required this.endTime,
    required this.slotMinutes,
    required this.priceType,
    required this.price,
  });

  final String startTime;
  final String endTime;
  final int slotMinutes;
  final String priceType;
  final num price;

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'slotMinutes': slotMinutes,
      'priceType': priceType,
      'price': price,
    };
  }
}
