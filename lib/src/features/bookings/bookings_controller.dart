import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../app/use_cases/app_use_case.dart';
import '../../core/error/app_exception.dart';
import '../../core/state/disposable_notifier.dart';
import '../../core/utils/app_formatters.dart';

final myBookingsControllerProvider = FutureProvider.autoDispose<List<Booking>>((
  ref,
) {
  return ref.watch(appUseCaseProvider).bookings.getMyBookings();
});

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

final createBookingControllerProvider = StateNotifierProvider.autoDispose
    .family<CreateBookingController, CreateBookingState, List<PitchPrice>>((ref, prices) {
  return CreateBookingController(ref, prices);
});

class CreateBookingController extends StateNotifier<CreateBookingState> with DisposableNotifierMixin<CreateBookingState> {
  CreateBookingController(this._ref, List<PitchPrice> prices)
      : super(
          CreateBookingState(
            customerName: _ref.read(appSessionProvider)?.user.fullName ?? '',
            customerPhone: _ref.read(appSessionProvider)?.user.phone ?? '',
            selectedDate: DateTime.now(),
            note: '',
            prices: prices,
          ),
        ) {
    nameController = registerDisposable(TextEditingController(text: state.customerName));
    phoneController = registerDisposable(TextEditingController(text: state.customerPhone));
    dateController = registerDisposable(TextEditingController(
      text: AppFormatters.date(state.selectedDate),
    ));
    noteController = registerDisposable(TextEditingController(text: state.note));

    nameController.addListener(() {
      updateName(nameController.text);
    });
    phoneController.addListener(() {
      updatePhone(phoneController.text);
    });
    noteController.addListener(() {
      updateNote(noteController.text);
    });
  }

  final Ref _ref;
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController dateController;
  late final TextEditingController noteController;

  void updateName(String name) {
    if (state.customerName != name) {
      state = state.copyWith(customerName: name);
    }
  }

  void updatePhone(String phone) {
    if (state.customerPhone != phone) {
      state = state.copyWith(customerPhone: phone);
    }
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date, selectedSlotStart: () => null);
    final dateStr = AppFormatters.date(date);
    if (dateController.text != dateStr) {
      dateController.text = dateStr;
    }
  }

  void updateNote(String note) {
    if (state.note != note) {
      state = state.copyWith(note: note);
    }
  }

  void selectSlot(DateTime startTime) {
    state = state.copyWith(selectedSlotStart: () => startTime);
  }

  Future<void> submit({
    required String pitchId,
    required void Function(String message) onError,
    required void Function() onSuccess,
  }) async {
    final slot = state.selectedSlot;
    if (slot == null) {
      onError('Vui lòng chọn khung giờ hợp lệ');
      return;
    }

    state = state.copyWith(submitStatus: const AsyncLoading());

    final result = await AsyncValue.guard(() {
      return _ref.read(appUseCaseProvider).bookings.createBooking(
            CreateBookingRequest(
              pitchId: pitchId,
              customerName: state.customerName.trim(),
              customerPhone: state.customerPhone.trim(),
              startTime: slot.startTime,
              endTime: slot.endTime,
              note: state.note.trim(),
            ),
          );
    });

    state = state.copyWith(submitStatus: result);

    if (result is AsyncError) {
      onError(_bookingErrorMessage(result.error));
    } else if (result is AsyncData && result.value != null) {
      _ref.invalidate(myBookingsControllerProvider);
      onSuccess();
    }
  }

  String _bookingErrorMessage(Object? error) {
    if (error is AppException) {
      if (error.message.contains('chưa được cấu hình giá')) {
        return 'Sân này chưa có bảng giá cho khung giờ đã chọn.';
      }
      return error.message;
    }
    return 'Không tạo được booking';
  }
}

