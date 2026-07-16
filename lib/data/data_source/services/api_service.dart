import 'package:atm_soundbox/data/models/request/login_request.dart';
import 'package:dio/dio.dart';
import 'package:atm_soundbox/data/models/response/base_response.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('/auth/login')
  Future<BaseResponse> login(
    @Body() LoginRequest request,
  );
}
