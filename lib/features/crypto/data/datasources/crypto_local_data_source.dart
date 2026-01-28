import 'package:crypto_flow/features/crypto/data/models/crypto_model.dart';
import 'package:hive/hive.dart';

class CryptoLocalDataSource {
  final Box box;

  CryptoLocalDataSource(this.box);

  Future<void> cacheCryptos(List<CryptoModel> cryptos) async {
    final jsonList = cryptos.map((e) => e.toJson()).toList();
    await box.put('cached_cryptos', jsonList);
  }

  Future<List<CryptoModel>> getLastCryptos() async {
    final dynamic data = box.get('cached_cryptos');
    if (data == null) return [];

    final List<dynamic> jsonList = data;
    return jsonList.map((e) => CryptoModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
