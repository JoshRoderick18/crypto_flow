import 'package:crypto_flow/core/http_client.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_local_data_source.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'package:crypto_flow/features/crypto/data/repositories/crypto_repository_impl.dart';
import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:crypto_flow/features/crypto/presentation/state/crypto_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final dioProvider = Provider<Dio>((ref) => DioClient().dio);
final cryptoBoxProvider = Provider<Box>((ref) => throw UnimplementedError());

final remoteDSProvider = Provider((ref) => CryptoRemoteDataSource(ref.read(dioProvider)));
final localDSProvider = Provider((ref) => CryptoLocalDataSource(ref.read(cryptoBoxProvider)));

final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) => CryptoRepositoryImpl(ref.read(remoteDSProvider), ref.read(localDSProvider)));
final cryptoNotifierProvider = AsyncNotifierProvider.autoDispose<CryptoNotifier, List<CryptoEntity>>(() => CryptoNotifier());

final globalMessageProvider = StateProvider<String?>((ref) => null);
