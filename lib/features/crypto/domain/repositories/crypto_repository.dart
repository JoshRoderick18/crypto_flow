import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';

abstract class CryptoRepository {
  Future<List<CryptoEntity>> getCryptos();
}
