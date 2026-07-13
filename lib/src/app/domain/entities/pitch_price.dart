class PitchPrice {
  const PitchPrice({
    required this.id,
    required this.pitchId,
    required this.pitchName,
    required this.startTime,
    required this.endTime,
    required this.slotMinutes,
    required this.priceType,
    required this.price,
  });

  final String id;
  final String pitchId;
  final String pitchName;
  final String startTime;
  final String endTime;
  final int slotMinutes;
  final String priceType;
  final num price;
}
