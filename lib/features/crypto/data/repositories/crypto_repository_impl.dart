import 'package:crypto_flow/features/crypto/data/datasources/crypto_local_data_source.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'package:crypto_flow/features/crypto/data/models/crypto_model.dart';
import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/domain/repositories/crypto_repository.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;
  final CryptoLocalDataSource localDataSource;

  CryptoRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<(List<CryptoEntity>, bool)> getCryptos() async {
    try {
      final models = await remoteDataSource.getAll();

      await localDataSource.cacheCryptos(models);

      return (models.map((e) => e.toEntity()).toList(), false);
    } catch (e) {
      try {
        final localModels = await localDataSource.getLastCryptos();
        if (localModels.isNotEmpty) {
          return (localModels.map((e) => e.toEntity()).toList(), true);
        }
        throw Exception('No internet and no cache data');
      } catch (_) {
        rethrow;
      }
    }
  }
}
