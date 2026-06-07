import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_music/core/network/Auth_Intercepter.dart';


class Dio_Private_Client {
  static final Dio_Private_Client _instance = Dio_Private_Client._internal();
  late Dio dio;

  factory Dio_Private_Client() => _instance;

  Dio_Private_Client._internal() {
    dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL']!,
        headers: {'Content-Type': 'application/json'},
    ));
    dio.interceptors.add(Auth_Interceptor(dio));
  }
}
