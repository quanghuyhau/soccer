import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:soccer/data/models/request/login_request.dart';
import 'package:soccer/data/models/response/base_response.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('/auth/login')
  Future<BaseResponse> login(
    @Body() LoginRequest request,
  );
}
