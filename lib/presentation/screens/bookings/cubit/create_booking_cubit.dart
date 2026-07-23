import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/application/app_session.dart';
import 'package:soccer/presentation/screens/bookings/state/bookings_state.dart';
import 'package:soccer/utilities/utils/app_exception.dart';
import 'package:soccer/utilities/utils/app_formatters.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  CreateBookingCubit({
    required AppUseCase useCase,
    required AppSessionCubit sessionCubit,
    required List<PitchPrice> prices,
  }) : _useCase = useCase,
       super(
         CreateBookingState(
           customerName: sessionCubit.state?.user.fullName ?? '',
           customerPhone: sessionCubit.state?.user.phone ?? '',
           selectedDate: DateTime.now(),
           note: '',
           prices: prices,
         ),
       ) {
    nameController = TextEditingController(text: state.customerName);
    phoneController = TextEditingController(text: state.customerPhone);
    dateController = TextEditingController(
      text: AppFormatters.date(state.selectedDate),
    );
    noteController = TextEditingController(text: state.note);

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

  final AppUseCase _useCase;
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController dateController;
  late final TextEditingController noteController;

  void updateName(String name) {
    if (state.customerName != name) {
      emit(state.copyWith(customerName: name));
    }
  }

  void updatePhone(String phone) {
    if (state.customerPhone != phone) {
      emit(state.copyWith(customerPhone: phone));
    }
  }

  void updateDate(DateTime date) {
    emit(state.copyWith(selectedDate: date, selectedSlotStart: () => null));
    final dateStr = AppFormatters.date(date);
    if (dateController.text != dateStr) {
      dateController.text = dateStr;
    }
  }

  void updateNote(String note) {
    if (state.note != note) {
      emit(state.copyWith(note: note));
    }
  }

  void selectSlot(DateTime startTime) {
    emit(state.copyWith(selectedSlotStart: () => startTime));
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

    emit(state.copyWith(submitStatus: const CreateBookingSubmitLoading()));

    try {
      final booking = await _useCase.bookings.createBooking(
        CreateBookingRequest(
          pitchId: pitchId,
          customerName: state.customerName.trim(),
          customerPhone: state.customerPhone.trim(),
          startTime: slot.startTime,
          endTime: slot.endTime,
          note: state.note.trim(),
        ),
      );
      emit(state.copyWith(submitStatus: CreateBookingSubmitSuccess(booking)));
      onSuccess();
    } catch (error, stackTrace) {
      final failure = CreateBookingSubmitFailure.from(error, stackTrace);
      emit(state.copyWith(submitStatus: failure));
      onError(_bookingErrorMessage(failure.error ?? failure.message));
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

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    dateController.dispose();
    noteController.dispose();
    return super.close();
  }
}
