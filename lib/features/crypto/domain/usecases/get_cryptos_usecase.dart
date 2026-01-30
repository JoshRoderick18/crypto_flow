import 'package:crypto_flow/core/error/failures.dart';
import 'package:crypto_flow/core/result/result.dart';
import 'package:crypto_flow/core/usecase/usecase.dart';
import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/domain/repositories/crypto_repository.dart';

class CryptosResponse {
  final List<CryptoEntity> cryptos;
  final bool isFromCache;

  const CryptosResponse({required this.cryptos, this.isFromCache = false});
}

class GetCryptosUseCase extends UseCase<CryptosResponse, NoParams> {
  final CryptoRepository repository;

  GetCryptosUseCase(this.repository);

  @override
  Future<Result<CryptosResponse, AppFailure>> call(NoParams params) async {
    return await repository.getCryptos();
  }
}
