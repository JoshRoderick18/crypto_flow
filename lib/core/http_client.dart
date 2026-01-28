import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.coingecko.com/api/v3',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'accept': 'application/json', 'x-cg-demo-api-key': dotenv.env['COINGECKO_API_KEY'] ?? ''},
        ),
      );
}
