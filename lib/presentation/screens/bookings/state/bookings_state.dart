import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/common/base_state.dart';
import 'package:soccer/utilities/utils/app_formatters.dart';

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

class CreateBookingState extends BaseState {
  const CreateBookingState({
    required this.customerName,
    required this.customerPhone,
    required this.selectedDate,
    required this.note,
    this.selectedSlotStart,
    this.prices = const [],
    this.submitStatus = const CreateBookingSubmitInitial(),
  });

  final String customerName;
  final String customerPhone;
  final DateTime selectedDate;
  final String note;
  final DateTime? selectedSlotStart;
  final List<PitchPrice> prices;
  final CreateBookingSubmitState submitStatus;

  CreateBookingState copyWith({
    String? customerName,
    String? customerPhone,
    DateTime? selectedDate,
    String? note,
    DateTime? Function()? selectedSlotStart,
    List<PitchPrice>? prices,
    CreateBookingSubmitState? submitStatus,
  }) {
    return CreateBookingState(
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      selectedDate: selectedDate ?? this.selectedDate,
      note: note ?? this.note,
      selectedSlotStart: selectedSlotStart != null
          ? selectedSlotStart()
          : this.selectedSlotStart,
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

sealed class CreateBookingSubmitState extends AppState<Booking?> {
  const CreateBookingSubmitState();
}

class CreateBookingSubmitInitial extends AppInitial<Booking?>
    implements CreateBookingSubmitState {
  const CreateBookingSubmitInitial();
}

class CreateBookingSubmitLoading extends AppLoading<Booking?>
    implements CreateBookingSubmitState {
  const CreateBookingSubmitLoading();
}

class CreateBookingSubmitSuccess extends AppSuccess<Booking?>
    implements CreateBookingSubmitState {
  const CreateBookingSubmitSuccess(super.data);
}

class CreateBookingSubmitFailure extends AppFailure<Booking?>
    implements CreateBookingSubmitState {
  const CreateBookingSubmitFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory CreateBookingSubmitFailure.from(
    Object error, [
    StackTrace? stackTrace,
  ]) {
    final failure = AppFailure<Booking?>.from(error, stackTrace);
    return CreateBookingSubmitFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
