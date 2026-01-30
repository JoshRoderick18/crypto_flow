import 'package:crypto_flow/core/error/failures.dart';
import 'package:crypto_flow/core/result/result.dart';
import 'package:crypto_flow/features/crypto/domain/usecases/get_cryptos_usecase.dart';

abstract class CryptoRepository {
  Future<Result<CryptosResponse, AppFailure>> getCryptos();
}
