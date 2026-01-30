import 'dart:io';

import 'package:crypto_flow/core/error/failures.dart';
import 'package:crypto_flow/core/result/result.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_local_data_source.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'package:crypto_flow/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:crypto_flow/features/crypto/domain/usecases/get_cryptos_usecase.dart';
import 'package:dio/dio.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;
  final CryptoLocalDataSource localDataSource;

  CryptoRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<CryptosResponse, AppFailure>> getCryptos() async {
    try {
      final models = await remoteDataSource.getAll();
      await localDataSource.cacheCryptos(models);
      return Success(CryptosResponse(cryptos: models.map((e) => e.toEntity()).toList(), isFromCache: false));
    } on DioException catch (e, stackTrace) {
      return _handleNetworkError(e, stackTrace);
    } on SocketException catch (_, stackTrace) {
      return _tryGetFromCache(stackTrace);
    } catch (e, stackTrace) {
      return _tryGetFromCache(stackTrace, originalError: e);
    }
  }

  Future<Result<CryptosResponse, AppFailure>> _handleNetworkError(DioException e, StackTrace stackTrace) async {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return _tryGetFromCache(stackTrace);

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;

        if (statusCode == 429) {
          final cacheResult = await _tryGetFromCache(stackTrace);
          if (cacheResult.isSuccess) return cacheResult;
          return Failure(RateLimitFailure(stackTrace: stackTrace));
        }

        if (statusCode != null && statusCode >= 500) {
          final cacheResult = await _tryGetFromCache(stackTrace);
          if (cacheResult.isSuccess) return cacheResult;
          return Failure(ServerFailure(statusCode: statusCode, message: 'Error del servidor ($statusCode)', stackTrace: stackTrace));
        }

        return _tryGetFromCache(stackTrace);

      default:
        return _tryGetFromCache(stackTrace);
    }
  }

  Future<Result<CryptosResponse, AppFailure>> _tryGetFromCache(StackTrace stackTrace, {Object? originalError}) async {
    try {
      final localModels = await localDataSource.getLastCryptos();

      if (localModels.isNotEmpty) {
        return Success(CryptosResponse(cryptos: localModels.map((e) => e.toEntity()).toList(), isFromCache: true));
      }

      return Failure(NoDataFailure(message: 'Sin conexión y sin datos en caché', stackTrace: stackTrace));
    } catch (cacheError, cacheStackTrace) {
      return Failure(CacheFailure(message: 'Error al acceder a datos locales', stackTrace: cacheStackTrace));
    }
  }
}
