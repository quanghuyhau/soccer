import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/utils/app_formatters.dart';

class BookingSlot {
  const BookingSlot({
    required this.startTime,
    required this.endTime,
    required this.price,
  });

  final DateTime startTime;
  final DateTime endTime;
  final PitchPrice price;
}

class CreateBookingState {
  const CreateBookingState({
    required this.customerName,
    required this.customerPhone,
    required this.selectedDate,
    required this.note,
    this.selectedSlotStart,
    this.prices = const [],
    this.submitStatus = const AsyncData(null),
  });

  final String customerName;
  final String customerPhone;
  final DateTime selectedDate;
  final String note;
  final DateTime? selectedSlotStart;
  final List<PitchPrice> prices;
  final AsyncValue<Booking?> submitStatus;

  CreateBookingState copyWith({
    String? customerName,
    String? customerPhone,
    DateTime? selectedDate,
    String? note,
    DateTime? Function()? selectedSlotStart,
    List<PitchPrice>? prices,
    AsyncValue<Booking?>? submitStatus,
  }) {
    return CreateBookingState(
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      selectedDate: selectedDate ?? this.selectedDate,
      note: note ?? this.note,
      selectedSlotStart: selectedSlotStart != null ? selectedSlotStart() : this.selectedSlotStart,
      prices: prices ?? this.prices,
      submitStatus: submitStatus ?? this.submitStatus,
    );
  }

  List<BookingSlot> get availableSlots {
    final slots = <BookingSlot>[];
    const slotMinutes = 90;
    const slotDuration = Duration(minutes: slotMinutes);

    for (final price in prices) {
      if (price.slotMinutes != slotMinutes) {
        continue;
      }

      final dateStr = AppFormatters.date(selectedDate);
      final rangeStart = _dateTimeAt(dateStr, price.startTime);
      var rangeEnd = _dateTimeAt(dateStr, price.endTime);

      if (rangeStart == null || rangeEnd == null) {
        continue;
      }

      if (!rangeEnd.isAfter(rangeStart)) {
        rangeEnd = rangeEnd.add(const Duration(days: 1));
      }

      var cursor = rangeStart;
      while (!cursor.add(slotDuration).isAfter(rangeEnd)) {
        slots.add(
          BookingSlot(
            startTime: cursor,
            endTime: cursor.add(slotDuration),
            price: price,
          ),
        );
        cursor = cursor.add(slotDuration);
      }
    }

    slots.sort((a, b) => a.startTime.compareTo(b.startTime));
    return slots;
  }

  BookingSlot? get selectedSlot {
    final slots = availableSlots;
    if (slots.isEmpty) {
      return null;
    }

    for (final slot in slots) {
      if (slot.startTime == selectedSlotStart) {
        return slot;
      }
    }

    return slots.first;
  }

  DateTime? _dateTimeAt(String date, String time) {
    final normalizedTime = time.length == 5 ? '$time:00' : time;
    return DateTime.tryParse('${date}T$normalizedTime');
  }
}
