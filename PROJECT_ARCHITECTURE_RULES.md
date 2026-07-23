# Project Architecture Rules

File này là bản đồ kiến trúc của app. Trước khi sửa hoặc thêm tính năng, đọc file này trước để biết phải đi vào tầng nào, file nào, và không cần scan lại toàn bộ dự án.

## 1. Stack hiện tại

- App Flutter dùng `flutter_bloc` cho state.
- DI dùng `get_it + injectable`.
- API dùng `dio`.
- Log API dùng logger nội bộ + `curl_logger_dio_interceptor`.
- Kiến trúc chính: `data -> domain -> presentation`.
- Không dùng Riverpod trong base hiện tại.
- Không dùng thư mục `lib/src`; toàn bộ code chính nằm trực tiếp dưới `lib/`.

## 2. Cấu trúc thư mục chuẩn

```text
lib/
  data/
    data_source/
      services/          API client, endpoint, Dio, datasource, socket datasource
    models/
      request/           Request gửi lên backend
      response/          Response nhận từ backend, map sang entity
    repositories/        Repository implementation

  domain/
    entities/            Model sạch app dùng
    repositories/        Contract repository
    use_cases/           Nghiệp vụ app

  di/
    di.dart              getIt + injectable init
    di.config.dart       File generate, không sửa tay
    environment/         Base URL, build config
    module/              Export module phụ

  presentation/
    application/         App root, session, auth gate
    common/              Base state, base screen, popup, button, design system
    screens/
      feature/
        cubit/           Cubit của feature
        state/           State riêng của feature
        ui/              Screen/widget của feature

  utilities/
    constants/
    extensions/
    routes/
    style/
    utils/
```

## 3. Luồng chạy app

App bắt đầu ở:

```text
lib/main.dart
```

Luồng:

```text
main()
  -> configureDependencies()
  -> SoccerApp
  -> MultiRepositoryProvider / MultiBlocProvider
  -> AuthGate
  -> nếu chưa login: LoginScreen
  -> nếu đã login: MainShell
```

Các file cần đọc theo thứ tự:

1. `lib/main.dart`
2. `lib/di/di.dart`
3. `lib/presentation/application/application.dart`
4. `lib/presentation/application/auth_gate.dart`
5. `lib/presentation/screens/shell/ui/main_shell.dart`

## 4. DI rule

DI dùng `get_it + injectable`.

File chính:

```text
lib/di/di.dart
lib/di/di.config.dart
```

Rule:

- Class dùng chung lâu dài: dùng `@lazySingleton`.
- Cubit tạo mới theo màn/tác vụ: dùng `@injectable`.
- Repository implementation: dùng `@LazySingleton(as: XxxRepository)`.
- Không sửa tay `di.config.dart`.
- Sau khi thêm annotation DI, chạy:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Ví dụ:

```dart
@lazySingleton
class BookingUseCase {
  const BookingUseCase(this._repository);

  final BookingRepository _repository;
}
```

```dart
@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl extends BaseRepository
    implements BookingRepository {
  const BookingRepositoryImpl(this._dataSource);
}
```

## 5. Dependency flow

Luồng phụ thuộc chuẩn:

```text
Dio
  -> ApiClient
  -> DataSource
  -> RepositoryImpl
  -> Repository contract
  -> UseCase
  -> Cubit
  -> Screen
```

Tầng trên chỉ được gọi tầng ngay bên dưới:

- UI gọi Cubit.
- Cubit gọi UseCase.
- UseCase gọi Repository contract.
- RepositoryImpl gọi DataSource.
- DataSource gọi ApiClient.
- ApiClient gọi Dio.

Không gọi tắt kiểu:

- UI gọi thẳng Repository.
- Cubit gọi thẳng DataSource.
- DataSource import UI.
- Domain import Data hoặc Presentation.

## 6. Data layer rule

Data layer nằm ở:

```text
lib/data/
```

Nhiệm vụ:

- Gọi API.
- Parse JSON.
- Bọc lỗi backend.
- Chuyển response backend thành object app hiểu được.

Các file lõi:

```text
lib/data/data_source/services/api_client.dart
lib/data/data_source/services/api_envelope_parser.dart
lib/data/data_source/services/backend_error_mapper.dart
lib/data/data_source/services/app_endpoints.dart
```

### Endpoint

Tất cả endpoint đặt ở:

```text
lib/data/data_source/services/app_endpoints.dart
```

Không hard-code endpoint trong screen/cubit.

Ví dụ:

```dart
static const bookings = '/api/bookings';
static String pitchPrices(String pitchId) => '/api/pitches/$pitchId/prices';
```

### DataSource

DataSource chỉ gọi API và parse response.

Ví dụ:

```dart
Future<BookingResponse> createBooking(CreateBookingRequest request) async {
  final response = await _apiClient.post<Map<String, dynamic>>(
    AppEndpoints.bookings,
    data: request.toJson(),
    parser: parseApiObject,
  );

  return BookingResponse.fromJson(response.data);
}
```

Rule:

- Request lấy từ `lib/data/models/request/`.
- Response lấy từ `lib/data/models/response/`.
- Nếu API trả object trong `result`: dùng `parseApiObject`.
- Nếu API trả list trong `result`: dùng `parseApiObjectList`.
- Nếu API chỉ cần thành công, không cần result: dùng `parseApiSuccess`.

## 7. API response envelope

Backend trả dạng:

```json
{
  "code": 200,
  "message": "OK",
  "result": {}
}
```

File xử lý:

```text
lib/data/data_source/services/api_envelope_parser.dart
```

Ý nghĩa:

- `parseJsonObject`: đảm bảo response là JSON object.
- `parseApiObject`: lấy `result` dạng object.
- `parseApiObjectList`: lấy `result` dạng list object.
- `parseApiSuccess`: chỉ check `code`, không lấy result.

Nếu `code >= 400`, parser sẽ throw `AppException.backend`.

## 8. Error rule

App chỉ dùng một loại lỗi chung:

```text
lib/utilities/utils/app_exception.dart
```

`AppException` có:

- `message`: message backend trả về hoặc message lỗi mạng.
- `type`: backend/network/parsing/cancelled/unknown.
- `statusCode`: HTTP status.
- `backendCode`: code backend.
- `errors`: lỗi field nếu backend trả thêm.

Mapper nằm ở:

```text
lib/data/data_source/services/backend_error_mapper.dart
```

Rule:

- Backend message đã có tiếng Việt thì ưu tiên show thẳng `failure.message`.
- Muốn đổi title/icon popup theo mã lỗi thì sửa ở:

```text
lib/presentation/common/widgets/base_popup.dart
```

Cụ thể:

```dart
BasePopup.titleOfFailure(...)
```

Không tạo nhiều exception kiểu `BadRequestException`, `UnauthorizedException`. Base hiện tại đã gom về `AppException.backend`.

## 9. Repository rule

Repository contract nằm ở:

```text
lib/domain/repositories/
```

Repository implementation nằm ở:

```text
lib/data/repositories/
```

Contract định nghĩa app cần gì:

```dart
abstract interface class BookingRepository {
  Future<Booking> createBooking(CreateBookingRequest request);
}
```

Implementation gọi DataSource:

```dart
@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl extends BaseRepository
    implements BookingRepository {
  const BookingRepositoryImpl(this._dataSource);

  final BookingDataSource _dataSource;

  Future<Booking> createBooking(CreateBookingRequest request) {
    return executeDataSourceRequest(() => _dataSource.createBooking(request));
  }
}
```

Rule:

- RepositoryImpl luôn extend `BaseRepository`.
- Gọi DataSource qua `executeDataSourceRequest`.
- Repository trả entity/domain type, không trả raw JSON.
- Nếu Response extends Entity thì có thể trả trực tiếp response object như hiện tại.

## 10. UseCase rule

UseCase nằm ở:

```text
lib/domain/use_cases/
```

UseCase chứa nghiệp vụ app.

Ví dụ login:

```text
AuthUseCase.login()
  -> repository.login() lấy token
  -> repository.getCurrentUser() lấy user hiện tại
  -> trả AuthSessionData(tokens, user)
```

UseCase khác Repository ở điểm:

- Repository chỉ biết lấy/lưu dữ liệu.
- UseCase biết nghiệp vụ cần gọi bao nhiêu repo/API và ghép dữ liệu như nào.

Rule:

- Một nhóm nghiệp vụ gom trong một usecase theo domain: `AuthUseCase`, `BookingUseCase`, `VenueUseCase`, `RealtimeUseCase`.
- Không tạo quá nhiều file `create_x_use_case.dart` nếu nghiệp vụ nhỏ.
- Không để logic nghiệp vụ dài trong Cubit.

## 11. AppRepository và AppUseCase

Hai file gom nhóm:

```text
lib/domain/repositories/app_repository.dart
lib/domain/use_cases/app_use_case.dart
```

Ý nghĩa:

- `AppRepository`: gom các repository theo domain.
- `AppUseCase`: gom các usecase theo domain.

Ví dụ gọi từ Cubit:

```dart
_useCase.auth.login(...)
_useCase.bookings.createBooking(...)
_useCase.venues.getVenues(...)
_useCase.realtime.connectBookingSocket(...)
```

Rule:

- Feature mới có domain mới thì thêm field vào `AppUseCase` và `AppRepository` nếu muốn gọi qua cổng gom.
- Nếu chỉ dùng trực tiếp usecase qua DI cũng được, nhưng base hiện tại đang ưu tiên gọi qua `AppUseCase`.

## 12. Entity, Request, Response

### Request

Nằm ở:

```text
lib/data/models/request/
```

Nhiệm vụ:

- Đại diện body gửi lên backend.
- Có `toJson()`.

### Response

Nằm ở:

```text
lib/data/models/response/
```

Nhiệm vụ:

- Đại diện JSON backend trả về.
- Có `fromJson()`.
- Có thể extend entity nếu fields giống domain.

### Entity

Nằm ở:

```text
lib/domain/entities/
```

Nhiệm vụ:

- Model sạch app dùng ở domain/presentation.
- Không phụ thuộc backend JSON.
- UI/Cubit nên làm việc với entity.

Rule:

- Backend đổi field JSON: sửa Response.
- App đổi nghiệp vụ: sửa Entity/UseCase.
- Form gửi backend: sửa Request.

## 13. Presentation rule

Presentation nằm ở:

```text
lib/presentation/
```

Mỗi feature nên theo cấu trúc:

```text
presentation/screens/feature/
  cubit/
    feature_cubit.dart
  state/
    feature_state.dart
  ui/
    feature_screen.dart
```

Rule:

- Screen chỉ render UI và gọi Cubit.
- Cubit xử lý action, gọi UseCase, emit State.
- State tách file riêng.
- Không gộp nhiều Cubit lớn vào một file.
- Không để API call trong screen.
- Không để business logic dài trong widget.

## 14. Cubit/state rule

Base state nằm ở:

```text
lib/presentation/common/base_state.dart
```

Có các state chung:

- `AppInitial<T>`
- `AppLoading<T>`
- `AppSuccess<T>`
- `AppFailure<T>`

Với feature cần state rõ tên thì tạo file state riêng:

```dart
sealed class AuthState extends AppState<void> {
  const AuthState();
}

class AuthLoading extends AppLoading<void> implements AuthState {
  const AuthLoading();
}

class AuthFailure extends AppFailure<void> implements AuthState {
  const AuthFailure({required super.message});
}
```

Rule:

- Tính năng đơn giản: state có thể extends `AppState<T>`.
- Tính năng có form nhiều field: tạo state riêng extend `BaseState` và có `copyWith`.
- Lỗi trong Cubit bắt bằng:

```dart
try {
  ...
} catch (error, stackTrace) {
  emit(FeatureFailure.from(error, stackTrace));
}
```

Không throw lỗi lên UI.

## 15. Popup/loading/toast rule

Base popup:

```text
lib/presentation/common/widgets/base_popup.dart
```

Base screen/loading:

```text
lib/presentation/common/widgets/base_screen.dart
lib/presentation/common/widgets/app_feedback.dart
lib/presentation/common/widgets/app_state_views.dart
```

Rule:

- Màn mới nên dùng `BaseScreen`, `BaseScrollScreen` hoặc `BaseAsyncScreen`.
- Loading toàn màn dùng `isLoading` của `BaseScreen`.
- Lỗi backend show bằng `BasePopup.showFailure(failure)`.
- Lỗi text thường show bằng `BasePopup.showError(message)`.
- Không tự tạo dialog lỗi riêng nếu base popup xử lý được.

## 16. UI/design rule

Design system nằm ở:

```text
lib/presentation/common/widgets/app_design.dart
lib/presentation/common/widgets/app_button.dart
lib/utilities/style/app_style.dart
```

Rule:

- Button dùng `AppButton`.
- Surface/card/panel dùng component trong `app_design.dart`.
- Màn dùng `BaseScreen` để giữ nền sân bóng đồng bộ.
- Màu lấy từ `AppColors`.
- Không hard-code style lặp lại nhiều nơi nếu đã có component chung.

## 17. Auth flow

Các file chính:

```text
lib/presentation/screens/login/cubit/login_cubit.dart
lib/presentation/screens/login/state/auth_state.dart
lib/domain/use_cases/login_use_case.dart
lib/domain/repositories/login_repository.dart
lib/data/repositories/login_repo_impl.dart
lib/data/data_source/services/auth_data_source.dart
lib/data/models/request/auth_request.dart
lib/data/models/response/auth_response.dart
lib/presentation/application/app_session.dart
lib/presentation/application/auth_gate.dart
```

Luồng login:

```text
LoginScreen
  -> AuthCubit.login(username, password)
  -> AuthUseCase.login(LoginRequest)
  -> AuthRepository.login()
  -> AuthDataSource.login()
  -> POST /api/auth/login
  -> nhận token
  -> AuthRepository.getCurrentUser(accessToken)
  -> GET /api/users/me
  -> tạo AuthSessionData
  -> AppSessionCubit.setSession(session)
  -> AuthGate đổi sang MainShell
```

## 18. Booking flow

Các file chính:

```text
lib/presentation/screens/bookings/
lib/domain/use_cases/booking_use_case.dart
lib/domain/repositories/booking_repository.dart
lib/data/repositories/booking_repository_impl.dart
lib/data/data_source/services/booking_data_source.dart
lib/data/models/request/booking_requests.dart
lib/data/models/response/booking_response.dart
```

Rule đặt sân hiện tại:

- App generate slot 90 phút từ bảng giá.
- User chọn startTime.
- App hiện tại vẫn gửi `startTime` và `endTime` trong `CreateBookingRequest`.
- Giá preview lấy từ bảng giá.
- Giá chính thức lấy từ response backend.

Nếu backend đổi request booking, sửa ở:

```text
lib/data/models/request/booking_requests.dart
lib/presentation/screens/bookings/cubit/create_booking_cubit.dart
```

## 19. Venue/Pitch flow

Các file chính:

```text
lib/presentation/screens/venues/
lib/presentation/screens/owner/
lib/domain/use_cases/venue_use_case.dart
lib/domain/repositories/venue_repository.dart
lib/domain/repositories/pitch_repository.dart
lib/data/repositories/venue_repository_impl.dart
lib/data/repositories/pitch_repository_impl.dart
lib/data/data_source/services/venue_data_source.dart
lib/data/data_source/services/pitch_data_source.dart
lib/data/models/request/venue_requests.dart
lib/data/models/request/pitch_requests.dart
lib/data/models/response/venue_response.dart
lib/data/models/response/pitch_response.dart
lib/data/models/response/pitch_price_response.dart
```

Rule:

- Customer xem cụm sân/sân và đặt lịch.
- Owner/Admin thấy tab quản lý trong `MainShell`.
- Tạo/sửa/xóa cụm sân, sân con, bảng giá nằm ở owner/venues cubit tương ứng.

## 20. Socket/realtime flow

Các file cần đọc theo thứ tự:

1. `lib/data/data_source/services/app_endpoints.dart`
2. `lib/di/environment/app_config.dart`
3. `lib/presentation/screens/owner/cubit/owner_realtime_cubit.dart`
4. `lib/domain/use_cases/realtime_use_case.dart`
5. `lib/domain/repositories/realtime_repository.dart`
6. `lib/data/repositories/realtime_repository_impl.dart`
7. `lib/data/data_source/services/realtime_socket_data_source.dart`
8. `lib/data/models/response/realtime_socket_event_response.dart`
9. `lib/domain/entities/realtime_event.dart`

Luồng:

```text
OwnerScreen
  -> OwnerRealtimeCubit
  -> lấy token từ AppSessionCubit
  -> AppConfig.socketUri('/ws/bookings')
  -> RealtimeUseCase.connectBookingSocket()
  -> RealtimeRepositoryImpl gắn Authorization header
  -> RealtimeSocketDataSource WebSocket.connect()
  -> backend push event
  -> RealtimeSocketEventResponse.fromJson()
  -> RealtimeEvent
  -> OwnerRealtimeCubit nghe event
  -> nếu event booking thì OwnerDashboardCubit.load()
  -> UI quản lý tự cập nhật
```

Rule:

- Socket chỉ mở ở owner realtime Cubit.
- Data source chịu trách nhiệm connect/reconnect/parse message.
- RepositoryImpl chịu trách nhiệm gắn token và map status.
- UseCase là cổng domain.
- Cubit quyết định UI reload gì khi có event.
- Muốn thêm event mới: sửa `RealtimeEventType`, `_eventType`, và logic Cubit nghe event.

## 21. Khi thêm một API mới

Làm theo checklist:

1. Thêm endpoint vào `app_endpoints.dart`.
2. Tạo/sửa request ở `data/models/request/`.
3. Tạo/sửa response ở `data/models/response/`.
4. Nếu cần model sạch, tạo/sửa entity ở `domain/entities/`.
5. Thêm hàm vào DataSource tương ứng.
6. Thêm hàm vào Repository contract.
7. Implement ở RepositoryImpl.
8. Thêm hàm nghiệp vụ vào UseCase.
9. Gọi từ Cubit.
10. Emit state success/failure.
11. UI dùng BlocBuilder/BlocListener để render/show popup.

## 22. Khi thêm một màn mới

Làm theo checklist:

1. Tạo folder:

```text
lib/presentation/screens/new_feature/
  cubit/
  state/
  ui/
```

2. Tạo `new_feature_state.dart`.
3. Tạo `new_feature_cubit.dart`.
4. Nếu Cubit cần DI, thêm `@injectable`.
5. Tạo `new_feature_screen.dart`.
6. Screen dùng `BaseScreen/BaseScrollScreen/BaseAsyncScreen`.
7. Nếu cần vào tab chính, sửa `MainShell`.
8. Nếu cần route, sửa `utilities/routes`.
9. Chạy build_runner nếu có DI annotation mới.

## 23. Khi thêm dependency DI mới

Nếu là class tự viết:

- Thêm `@lazySingleton` hoặc `@injectable`.
- Inject qua constructor.
- Chạy build_runner.

Nếu là dependency ngoài như Dio/shared prefs/service:

- Khai báo trong `lib/di/di.dart` hoặc module phù hợp.
- Chạy build_runner.

Không tự `new Dio()`, `new ApiClient()` trong screen/cubit.

## 24. Các lệnh kiểm tra sau khi sửa

Sau khi sửa code nên chạy:

```bash
dart format lib test
flutter analyze
flutter test
```

Nếu có sửa DI annotation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 25. Quy tắc không phá base

- Không tạo lại `src`.
- Không quay lại Riverpod.
- Không gọi API trong UI.
- Không hard-code endpoint trong Cubit/Screen.
- Không sửa tay `di.config.dart`.
- Không gộp nhiều Cubit/state không liên quan vào một file.
- Không tạo popup/loading riêng nếu base đã có.
- Không đổi request/response/entity lẫn lộn.
- Không để domain import data hoặc presentation.
- Không để presentation import data source/repository impl.

## 26. File nên đọc theo mục tiêu

### Muốn hiểu toàn app

```text
main.dart
di/di.dart
presentation/application/application.dart
presentation/application/auth_gate.dart
presentation/screens/shell/ui/main_shell.dart
```

### Muốn sửa API

```text
data/data_source/services/app_endpoints.dart
data/data_source/services/api_client.dart
data/data_source/services/api_envelope_parser.dart
data/data_source/services/backend_error_mapper.dart
```

### Muốn sửa lỗi/popup

```text
utilities/utils/app_exception.dart
presentation/common/base_state.dart
presentation/common/widgets/base_popup.dart
```

### Muốn sửa UI base

```text
presentation/common/widgets/base_screen.dart
presentation/common/widgets/app_design.dart
presentation/common/widgets/app_button.dart
```

### Muốn sửa login

```text
presentation/screens/login/
domain/use_cases/login_use_case.dart
data/data_source/services/auth_data_source.dart
```

### Muốn sửa đặt sân

```text
presentation/screens/bookings/
domain/use_cases/booking_use_case.dart
data/data_source/services/booking_data_source.dart
```

### Muốn sửa quản lý sân

```text
presentation/screens/owner/
presentation/screens/venues/
domain/use_cases/venue_use_case.dart
data/data_source/services/venue_data_source.dart
data/data_source/services/pitch_data_source.dart
```

### Muốn sửa socket

```text
presentation/screens/owner/cubit/owner_realtime_cubit.dart
domain/use_cases/realtime_use_case.dart
data/data_source/services/realtime_socket_data_source.dart
```

