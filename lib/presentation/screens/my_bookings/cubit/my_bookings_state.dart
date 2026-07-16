part of 'my_bookings_cubit.dart';

abstract class MyBookingsState {}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final List<BookingResponse> bookings;
  final String? errorMessage;
  MyBookingsLoaded(this.bookings, {this.errorMessage});

  MyBookingsLoaded copyWith({
    List<BookingResponse>? bookings,
    String? errorMessage,
  }) {
    return MyBookingsLoaded(
      bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MyBookingsError extends MyBookingsState {
  final String message;
  MyBookingsError(this.message);
}
