import 'package:crypto_flow/features/crypto/data/models/crypto_model.dart';
import 'package:dio/dio.dart';

class CryptoRemoteDataSource {
  final Dio dio;

  CryptoRemoteDataSource(this.dio);

  Future<List<CryptoModel>> getAll() async {
    final response = await dio.get('/coins/markets', queryParameters: {'vs_currency': 'usd', 'order': 'market_cap_desc', 'per_page': 50, 'page': 1, 'sparkline': false});

    final List<dynamic> data = response.data;
    return data.map((json) => CryptoModel.fromJson(json)).toList();
  }
}
