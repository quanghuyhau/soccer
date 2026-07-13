import '../error/app_exception.dart';

sealed class AppState<T> {
  const AppState();

  const factory AppState.initial() = AppInitial<T>;
  const factory AppState.loading() = AppLoading<T>;
  const factory AppState.success([T? data]) = AppSuccess<T>;
  factory AppState.failure(Object error, [StackTrace? stackTrace]) {
    return AppFailure<T>.from(error, stackTrace);
  }

  static Future<AppState<T>> guard<T>(Future<T> Function() action) async {
    try {
      return AppSuccess<T>(await action());
    } catch (error, stackTrace) {
      return AppFailure<T>.from(error, stackTrace);
    }
  }

  bool get isInitial => this is AppInitial<T>;
  bool get isLoading => this is AppLoading<T>;
  bool get isSuccess => this is AppSuccess<T>;
  bool get isFailure => this is AppFailure<T>;

  AppFailure<T>? get failureOrNull {
    final state = this;
    return state is AppFailure<T> ? state : null;
  }

  T? get dataOrNull {
    final state = this;
    return state is AppSuccess<T> ? state.data : null;
  }
}

class AppInitial<T> extends AppState<T> {
  const AppInitial();
}

class AppLoading<T> extends AppState<T> {
  const AppLoading();
}

class AppSuccess<T> extends AppState<T> {
  const AppSuccess([this.data]);

  final T? data;
}

class AppFailure<T> extends AppState<T> {
  const AppFailure({
    required this.message,
    this.backendCode,
    this.statusCode,
    this.errors,
    this.error,
    this.stackTrace,
  });

  factory AppFailure.from(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return AppFailure<T>(
        message: error.message,
        backendCode: error.backendCode,
        statusCode: error.statusCode,
        errors: error is ValidationException ? error.errors : null,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return AppFailure<T>(
      message: error.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  final String message;
  final int? backendCode;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final Object? error;
  final StackTrace? stackTrace;

  bool hasBackendCode(int code) => backendCode == code;
}
