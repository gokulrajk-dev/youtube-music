import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RefreshDio {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
