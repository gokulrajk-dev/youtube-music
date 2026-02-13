import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Dio_public_client {
  static final Dio_public_client _instance = Dio_public_client._internal();
  late final Dio dio;

  factory Dio_public_client() => _instance;

  Dio_public_client._internal() {
    dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL']!,
        responseType: ResponseType.json,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10)));
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      request: true,
    ));
  }
}
