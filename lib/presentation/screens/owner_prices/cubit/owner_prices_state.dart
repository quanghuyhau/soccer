part of 'owner_prices_cubit.dart';

abstract class OwnerPricesState {}

class OwnerPricesInitial extends OwnerPricesState {}

class OwnerPricesLoading extends OwnerPricesState {}

class OwnerPricesLoaded extends OwnerPricesState {
  final List<PitchPriceResponse> prices;
  final String? errorMessage;
  OwnerPricesLoaded(this.prices, {this.errorMessage});

  OwnerPricesLoaded copyWith({
    List<PitchPriceResponse>? prices,
    String? errorMessage,
  }) {
    return OwnerPricesLoaded(
      prices ?? this.prices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OwnerPricesError extends OwnerPricesState {
  final String message;
  OwnerPricesError(this.message);
}
