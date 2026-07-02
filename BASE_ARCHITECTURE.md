# Base Architecture Guide

## Muc tieu

Base nay dung Flutter + Riverpod + Dio.

Feature folder chi giu phan man hinh va controller:

```text
lib/src/features/login/
  login_controller.dart
  login_screen.dart
```

Nhung phan dung chung nam trong `app/` va `core/`.

## Cau truc chinh

```text
lib/src/app/
  app.dart
  models/app_models.dart
  data_sources/app_data_source.dart
  repositories/
    app_repository.dart
    home_repository.dart
    login_repository.dart
    impl/
      home_repository_impl.dart
      login_repository_impl.dart
  use_cases/
    app_use_case.dart
    home/
      get_sample_item_use_case.dart
    login/
      login_use_case.dart

lib/src/core/
  config/app_config.dart
  error/app_exception.dart
  network/
    api_client.dart
    dio_provider.dart
    app_interceptor.dart
    curl_log_interceptor.dart
  repository/base_repository.dart
  usecase/usecase.dart
  widgets/
```

## Luong call API

Vi du login:

```text
LoginScreen
 -> LoginController.login()
 -> LoginUseCase
 -> LoginRepository
 -> LoginRepositoryImpl
 -> LoginDataSource
 -> ApiClient.post()
 -> Dio
 -> API
```

Vai tro tung tang:

```text
Screen: hien thi UI, bat su kien user
Controller: quan ly state, goi usecase
UseCase: dai dien cho mot action nghiep vu
Repository contract: dinh nghia ham ma app can
Repository impl: bat loi chung, goi datasource
DataSource: biet endpoint, goi ApiClient, parse response
ApiClient: base HTTP method va map loi Dio
Dio: thu vien call API that
```

## Riverpod trong base nay

`Provider` dung de tao va inject object.

Vi du:

```dart
final appUseCaseProvider = Provider<AppUseCase>((ref) {
  final repository = ref.watch(appRepositoryProvider);

  return AppUseCase(
    getSampleItem: GetSampleItemUseCase(repository.home),
    login: LoginUseCase(repository.login),
  );
});
```

Doan nay khong call API. No chi tao `AppUseCase` va noi dependency:

```text
AppRepository -> UseCase -> Controller
```

Trong controller:

```dart
final useCase = ref.read(appUseCaseProvider);
final response = await useCase.login(request);
```

`ref.watch(...)`: doc provider va rebuild UI/controller khi provider doi.

`ref.read(...)`: doc provider mot lan de goi ham, khong rebuild.

`ref.listen(...)`: nghe state de lam side effect nhu snackbar, dialog, navigate.

Neu quen Cubit, co the hieu:

```text
Cubit state       -> StateNotifier state
emit(...)         -> state = ...
context.read      -> ref.read
context.watch     -> ref.watch
BlocListener      -> ref.listen
```

## Login flow hien tai

Request:

```dart
class LoginRequest {
  const LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
```

Response:

```dart
class LoginResponse {
  const LoginResponse({
    required this.token,
    required this.userId,
    this.userName,
  });
}
```

Controller:

```dart
state = const AsyncLoading();

state = await AsyncValue.guard(() {
  return _ref.read(appUseCaseProvider).login(request);
});
```

`AsyncValue` co 3 trang thai chinh:

```text
AsyncLoading: dang call API
AsyncData: co data
AsyncError: co loi
```

## Them mot API moi

Vi du them `getProfile`.

### 1. Them model/request/response

File:

```text
lib/src/app/models/app_models.dart
```

Them:

```dart
class ProfileResponse {
  const ProfileResponse({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}
```

### 2. Them datasource

File:

```text
lib/src/app/data_sources/app_data_source.dart
```

Them vao `AppDataSource`:

```dart
final ProfileDataSource profile;
```

Khoi tao:

```dart
profile: ProfileDataSource(apiClient),
```

Them class:

```dart
class ProfileDataSource {
  const ProfileDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<ProfileResponseModel> getProfile() async {
    final json = await _apiClient.getJson('/profile');
    return ProfileResponseModel.fromJson(json);
  }
}
```

### 3. Them repository contract

Tao file:

```text
lib/src/app/repositories/profile_repository.dart
```

```dart
abstract interface class ProfileRepository {
  Future<ProfileResponse> getProfile();
}
```

### 4. Them repository impl

Tao file:

```text
lib/src/app/repositories/impl/profile_repository_impl.dart
```

```dart
class ProfileRepositoryImpl extends BaseRepository
    implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileDataSource _dataSource;

  @override
  Future<ProfileResponse> getProfile() {
    return guard(_dataSource.getProfile);
  }
}
```

### 5. Dang ky vao AppRepository

File:

```text
lib/src/app/repositories/app_repository.dart
```

Them field:

```dart
final ProfileRepository profile;
```

Khoi tao:

```dart
profile: ProfileRepositoryImpl(dataSource.profile),
```

### 6. Them usecase

Tao file:

```text
lib/src/app/use_cases/profile/get_profile_use_case.dart
```

```dart
class GetProfileUseCase implements UseCase<ProfileResponse, NoParams> {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<ProfileResponse> call(NoParams input) {
    return _repository.getProfile();
  }
}
```

### 7. Dang ky vao AppUseCase

File:

```text
lib/src/app/use_cases/app_use_case.dart
```

Them field:

```dart
final GetProfileUseCase getProfile;
```

Khoi tao:

```dart
getProfile: GetProfileUseCase(repository.profile),
```

### 8. Goi trong controller

```dart
final response = await ref
    .read(appUseCaseProvider)
    .getProfile(const NoParams());
```

## Log cURL

Dio da gan `CurlLogInterceptor`.

Moi request trong debug mode se in ra dang:

```text
curl -X POST -H 'Accept: application/json' --data-raw '{"email":"..."}' 'https://...'
```

File:

```text
lib/src/core/network/curl_log_interceptor.dart
```

Interceptor nay chay sau `AppInterceptor`, nen header token neu co se duoc log trong cURL.

## Bat loi

`ApiClient` map loi ve `AppException`:

```text
400 -> BadRequestException
401 -> UnauthorizedException
403 -> ForbiddenException
404 -> NotFoundException
422 -> ValidationException
timeout -> NetworkException
cancel -> CancelledException
con lai -> ServerException
```

Repository impl nen goi API qua:

```dart
return guard(() => _dataSource.someApi());
```

`guard()` se giu lai `AppException`, va doi loi la thanh `UnknownException`.

## Quy tac khi them feature moi

Feature folder chi nen co:

```text
feature_name_controller.dart
feature_name_screen.dart
```

Khong dat datasource/repository/usecase trong feature neu muon giu dung style base nay.

Tat ca API/repository/usecase moi them vao `app/`.

## Khi nao khong can AppUseCase/AppRepository

Co the bo `AppUseCase` va tao provider rieng cho tung usecase. Cach do ro hon cho nguoi moi, nhung nhieu provider hon.

Base hien tai chon cach gom:

```text
appUseCaseProvider
appRepositoryProvider
appDataSourceProvider
```

Muc dich la de controller chi can biet mot entry point, feature folder gon hon.
