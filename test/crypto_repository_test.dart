import 'package:crypto_flow/core/error/failures.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_local_data_source.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'package:crypto_flow/features/crypto/data/models/crypto_model.dart';
import 'package:crypto_flow/features/crypto/data/repositories/crypto_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements CryptoRemoteDataSource {}

class MockLocal extends Mock implements CryptoLocalDataSource {}

void main() {
  late CryptoRepositoryImpl repo;
  late MockRemote mockRemote;
  late MockLocal mockLocal;

  const tModel = CryptoModel(id: '1', symbol: 'btc', name: 'Bitcoin', imageUrl: 'url', currentPrice: 100);

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    repo = CryptoRepositoryImpl(mockRemote, mockLocal);
  });

  group('getCryptos -', () {
    test('Debe retornar Success con datos remotos y cachear', () async {
      when(() => mockRemote.getAll()).thenAnswer((_) async => [tModel]);
      when(() => mockLocal.cacheCryptos(any())).thenAnswer((_) async {});

      final result = await repo.getCryptos();

      expect(result.isSuccess, true);
      result.when(
        success: (response) {
          expect(response.cryptos.length, 1);
          expect(response.isFromCache, false);
          expect(response.cryptos.first.name, 'Bitcoin');
        },
        failure: (_) => fail('Should be success'),
      );
      verify(() => mockLocal.cacheCryptos([tModel])).called(1);
    });

    test('Debe usar cache si falla el remoto con excepción genérica', () async {
      when(() => mockRemote.getAll()).thenThrow(Exception());
      when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => [tModel]);

      final result = await repo.getCryptos();

      expect(result.isSuccess, true);
      result.when(
        success: (response) {
          expect(response.cryptos.length, 1);
          expect(response.isFromCache, true);
        },
        failure: (_) => fail('Should be success'),
      );
      verify(() => mockLocal.getLastCryptos()).called(1);
    });

    group('DioException handling -', () {
      test('Debe usar cache en connectionTimeout', () async {
        when(() => mockRemote.getAll()).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: '/'),
          ),
        );
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => [tModel]);

        final result = await repo.getCryptos();

        expect(result.isSuccess, true);
        result.when(success: (response) => expect(response.isFromCache, true), failure: (_) => fail('Should be success'));
      });

      test('Debe usar cache en receiveTimeout', () async {
        when(() => mockRemote.getAll()).thenThrow(
          DioException(
            type: DioExceptionType.receiveTimeout,
            requestOptions: RequestOptions(path: '/'),
          ),
        );
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => [tModel]);

        final result = await repo.getCryptos();

        expect(result.isSuccess, true);
      });

      test('Debe usar cache en connectionError', () async {
        when(() => mockRemote.getAll()).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/'),
          ),
        );
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => [tModel]);

        final result = await repo.getCryptos();

        expect(result.isSuccess, true);
      });

      test('Debe retornar RateLimitFailure en status 429 sin cache', () async {
        when(() => mockRemote.getAll()).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(statusCode: 429, requestOptions: RequestOptions(path: '/')),
            requestOptions: RequestOptions(path: '/'),
          ),
        );
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => []);

        final result = await repo.getCryptos();

        expect(result.isFailure, true);
        result.when(success: (_) => fail('Should be failure'), failure: (error) => expect(error, isA<RateLimitFailure>()));
      });

      test('Debe usar cache en status 429 si hay datos', () async {
        when(() => mockRemote.getAll()).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(statusCode: 429, requestOptions: RequestOptions(path: '/')),
            requestOptions: RequestOptions(path: '/'),
          ),
        );
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => [tModel]);

        final result = await repo.getCryptos();

        expect(result.isSuccess, true);
      });

      test('Debe retornar ServerFailure en status 500+ sin cache', () async {
        when(() => mockRemote.getAll()).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(statusCode: 503, requestOptions: RequestOptions(path: '/')),
            requestOptions: RequestOptions(path: '/'),
          ),
        );
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => []);

        final result = await repo.getCryptos();

        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should be failure'),
          failure: (error) {
            expect(error, isA<ServerFailure>());
            expect((error as ServerFailure).statusCode, 503);
          },
        );
      });

      test('Debe usar cache en status 500+ si hay datos', () async {
        when(() => mockRemote.getAll()).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(statusCode: 500, requestOptions: RequestOptions(path: '/')),
            requestOptions: RequestOptions(path: '/'),
          ),
        );
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => [tModel]);

        final result = await repo.getCryptos();

        expect(result.isSuccess, true);
      });
    });

    group('Cache failures -', () {
      test('Debe retornar NoDataFailure si no hay cache', () async {
        when(() => mockRemote.getAll()).thenThrow(Exception());
        when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => []);

        final result = await repo.getCryptos();

        expect(result.isFailure, true);
        result.when(success: (_) => fail('Should be failure'), failure: (error) => expect(error, isA<NoDataFailure>()));
      });

      test('Debe retornar CacheFailure si falla el acceso a cache', () async {
        when(() => mockRemote.getAll()).thenThrow(Exception());
        when(() => mockLocal.getLastCryptos()).thenThrow(Exception('Cache error'));

        final result = await repo.getCryptos();

        expect(result.isFailure, true);
        result.when(success: (_) => fail('Should be failure'), failure: (error) => expect(error, isA<CacheFailure>()));
      });
    });
  });
}
