# Pitch Booking App Architecture

Base nay dung Flutter + Riverpod + Dio theo style:

```text
features/  -> controller + screen
app/       -> model, datasource, repository, usecase, session
core/      -> network, error, widget base, formatter
```

## Base URL

File:

```text
lib/src/core/config/app_config.dart
```

Mac dinh dang cau hinh theo IP LAN hien tai:

```text
http://192.168.102.123:8090
```

Khi IP may backend thay doi, truyen IP moi bang dart-define:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.102.123:8090
```

Neu IP may doi, chay lai app voi IP moi.

App goi backend qua gateway, khong goi truc tiep user-service/booking-service.

## Cau truc hien tai

```text
lib/src/app/
  app.dart
  models/app_models.dart
  session/app_session.dart
  data_sources/app_data_source.dart
  repositories/
    app_repository.dart
    auth_repository.dart
    venue_repository.dart
    pitch_repository.dart
    booking_repository.dart
    impl/
      auth_repository_impl.dart
      venue_repository_impl.dart
      pitch_repository_impl.dart
      booking_repository_impl.dart
  use_cases/
    app_use_case.dart
    auth/
    venues/
    bookings/

lib/src/features/
  auth/
  shell/
  venues/
  bookings/
  owner/

lib/src/core/
  config/
  error/
  network/
  repository/
  usecase/
  utils/
  widgets/
```

## Luong call API

Vi du tao booking:

```text
CreateBookingScreen
 -> CreateBookingController
 -> AppUseCase.createBooking
 -> CreateBookingUseCase
 -> BookingRepository
 -> BookingRepositoryImpl
 -> BookingDataSource
 -> ApiClient.post('/api/bookings')
 -> Dio
 -> Gateway
```

Vai tro tung tang:

```text
Screen: hien thi UI, nhan input user
Controller: quan ly loading/data/error, goi usecase
UseCase: dai dien cho mot action nghiep vu
Repository contract: interface domain
Repository impl: goi datasource qua BaseRepository.guard()
DataSource: biet endpoint, unwrap response, parse model
ApiClient: HTTP method va map Dio error
Dio: call network
```

## Response format backend

Backend tra:

```json
{
  "code": 200,
  "message": "Thành công",
  "result": {}
}
```

DataSource unwrap `result`.

Vi du:

```dart
final response = await _apiClient.post<Map<String, dynamic>>(
  '/api/auth/login',
  data: request.toJson(),
  parser: _asJsonObject,
);

return AuthTokensModel.fromJson(_resultObject(response.data));
```

## Auth/session/token

Sau login:

```text
POST /api/auth/login
GET /api/users/me
```

`LoginUseCase` tra ve:

```dart
AuthSessionData(tokens: tokens, user: user)
```

Session duoc giu o:

```text
lib/src/app/session/app_session.dart
```

Interceptor lay token tu `appSessionProvider`:

```text
lib/src/core/network/auth_token_provider.dart
```

Dio gan:

```http
Authorization: Bearer <accessToken>
```

## Riverpod trong app nay

`Provider` tao dependency:

```dart
final appUseCaseProvider = Provider<AppUseCase>((ref) {
  final repository = ref.watch(appRepositoryProvider);
  return AppUseCase(...);
});
```

`StateNotifierProvider` dung cho controller co action:

```dart
state = const AsyncLoading();
state = await AsyncValue.guard(() {
  return _ref.read(appUseCaseProvider).createBooking(request);
});
```

`FutureProvider` dung cho man chi load data:

```dart
final venuesControllerProvider = FutureProvider.autoDispose<List<Venue>>((ref) {
  return ref.watch(appUseCaseProvider).getVenues();
});
```

Tuong duong Cubit:

```text
Cubit                 Riverpod
emit(state)           state = value
context.read          ref.read
context.watch         ref.watch
BlocListener          ref.listen
```

## Man hinh da co

```text
AuthScreen       -> login/register
MainShell        -> bottom navigation
VenuesScreen     -> GET /api/venues
VenueDetail      -> GET /api/venues/{id}, GET /api/venues/{id}/pitches
CreateBooking    -> POST /api/bookings
MyBookings       -> GET /api/bookings/me
OwnerScreen      -> GET /api/venues/owner/{ownerId}, GET /api/bookings,
                    PATCH /api/bookings/{id}/status
Profile tab      -> session user + logout
```

## Log cURL

Dio dung package:

```yaml
curl_logger_dio_interceptor
```

File:

```text
lib/src/core/network/dio_provider.dart
```

Dang bat:

```dart
CurlLoggerDioInterceptor(printOnSuccess: true)
```

Moi request thanh cong hoac loi deu co cURL de copy test.

## Them API moi

Vi du them API `GET /api/pitches/{id}/bookings`.

### 1. Model

Them request/response vao:

```text
lib/src/app/models/app_models.dart
```

### 2. DataSource

Them method vao dung datasource:

```dart
Future<List<BookingModel>> getBookingsByPitch(String pitchId) async {
  final json = await _apiClient.getJson('/api/pitches/$pitchId/bookings');
  return _resultList(json)
      .map((item) => BookingModel.fromJson(_asJsonObject(item)))
      .toList();
}
```

### 3. Repository contract

Them method vao:

```text
lib/src/app/repositories/booking_repository.dart
```

### 4. Repository impl

Them implementation vao:

```text
lib/src/app/repositories/impl/booking_repository_impl.dart
```

Luon boc qua:

```dart
return guard(() => _dataSource.someApi());
```

### 5. UseCase

Tao file trong:

```text
lib/src/app/use_cases/bookings/
```

### 6. Dang ky AppUseCase

Them field vao:

```text
lib/src/app/use_cases/app_use_case.dart
```

### 7. Controller

Feature controller goi:

```dart
ref.read(appUseCaseProvider).someUseCase(params);
```

### 8. Screen

Feature screen chi watch controller va hien thi UI.

## Quy tac giu base gon

```text
features/<feature>/
  <feature>_controller.dart
  <feature>_screen.dart
```

Khong dat datasource/repository/usecase trong feature.

Neu API moi thuoc business chung, them vao `app/`.

Neu la widget/format/error/network dung chung, them vao `core/`.

## Kiem tra

Chay:

```bash
dart analyze
```

Voi Flutter widget test:

```bash
flutter test
```

Trong moi truong sandbox hien tai, `flutter test` co the bi chan do Flutter can ghi cache SDK ngoai workspace.
