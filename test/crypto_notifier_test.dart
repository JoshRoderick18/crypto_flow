import 'package:crypto_flow/core/error/failures.dart';
import 'package:crypto_flow/core/result/result.dart';
import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:crypto_flow/features/crypto/domain/usecases/get_cryptos_usecase.dart';
import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements CryptoRepository {}

void main() {
  late MockRepo mockRepo;

  const tCoin = CryptoEntity(id: '1', symbol: 'btc', name: 'Bitcoin', imageUrl: '', currentPrice: 100);
  const tCoin2 = CryptoEntity(id: '2', symbol: 'eth', name: 'Ethereum', imageUrl: '', currentPrice: 50);

  setUp(() {
    mockRepo = MockRepo();
  });

  ProviderContainer makeProviderContainer(MockRepo repo) {
    return ProviderContainer(overrides: [cryptoRepositoryProvider.overrideWithValue(repo), getCryptosUseCaseProvider.overrideWithValue(GetCryptosUseCase(repo))]);
  }

  group('CryptoNotifier -', () {
    test('Debe cargar la lista inicial correctamente', () async {
      when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin], isFromCache: false)));
      final container = makeProviderContainer(mockRepo);

      container.listen(cryptoNotifierProvider, (_, __) {});
      await container.read(cryptoNotifierProvider.future);

      expect(container.read(cryptoNotifierProvider).value, equals([tCoin]));
    });

    test('Debe manejar múltiples cryptos', () async {
      when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin, tCoin2], isFromCache: false)));
      final container = makeProviderContainer(mockRepo);

      container.listen(cryptoNotifierProvider, (_, __) {});
      await container.read(cryptoNotifierProvider.future);

      final state = container.read(cryptoNotifierProvider).value!;
      expect(state.length, 2);
    });

    test('Debe retornar error cuando el repository falla con NetworkFailure', () async {
      when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Failure(NetworkFailure()));
      final container = makeProviderContainer(mockRepo);

      container.listen(cryptoNotifierProvider, (_, __) {});

      await expectLater(container.read(cryptoNotifierProvider.future), throwsA(predicate((e) => e is Exception && e.toString().contains('network_error'))));
    });

    test('Debe retornar error con ServerFailure', () async {
      when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Failure(ServerFailure(statusCode: 500)));
      final container = makeProviderContainer(mockRepo);

      container.listen(cryptoNotifierProvider, (_, __) {});

      await expectLater(container.read(cryptoNotifierProvider.future), throwsA(predicate((e) => e is Exception && e.toString().contains('server_error_500'))));
    });

    group('Search -', () {
      test('Debe filtrar por nombre', () async {
        when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin, tCoin2], isFromCache: false)));

        final container = makeProviderContainer(mockRepo);
        container.listen(cryptoNotifierProvider, (_, __) {});
        await container.read(cryptoNotifierProvider.future);

        container.read(cryptoNotifierProvider.notifier).search('Bit');
        await Future.delayed(const Duration(milliseconds: 600));

        final state = container.read(cryptoNotifierProvider).value!;
        expect(state.length, 1);
        expect(state.first.name, 'Bitcoin');
      });

      test('Debe filtrar por símbolo', () async {
        when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin, tCoin2], isFromCache: false)));

        final container = makeProviderContainer(mockRepo);
        container.listen(cryptoNotifierProvider, (_, __) {});
        await container.read(cryptoNotifierProvider.future);

        container.read(cryptoNotifierProvider.notifier).search('eth');
        await Future.delayed(const Duration(milliseconds: 600));

        final state = container.read(cryptoNotifierProvider).value!;
        expect(state.length, 1);
        expect(state.first.symbol, 'eth');
      });

      test('Debe mostrar todos con búsqueda vacía', () async {
        when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin, tCoin2], isFromCache: false)));

        final container = makeProviderContainer(mockRepo);
        container.listen(cryptoNotifierProvider, (_, __) {});
        await container.read(cryptoNotifierProvider.future);

        container.read(cryptoNotifierProvider.notifier).search('Bit');
        await Future.delayed(const Duration(milliseconds: 600));
        expect(container.read(cryptoNotifierProvider).value!.length, 1);

        container.read(cryptoNotifierProvider.notifier).search('');
        await Future.delayed(const Duration(milliseconds: 600));

        final state = container.read(cryptoNotifierProvider).value!;
        expect(state.length, 2);
      });

      test('Debe retornar lista vacía si no hay coincidencias', () async {
        when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin, tCoin2], isFromCache: false)));

        final container = makeProviderContainer(mockRepo);
        container.listen(cryptoNotifierProvider, (_, __) {});
        await container.read(cryptoNotifierProvider.future);

        container.read(cryptoNotifierProvider.notifier).search('xyz');
        await Future.delayed(const Duration(milliseconds: 600));

        final state = container.read(cryptoNotifierProvider).value!;
        expect(state.length, 0);
      });
    });

    group('Refresh -', () {
      test('Debe recargar datos correctamente', () async {
        when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin], isFromCache: false)));

        final container = makeProviderContainer(mockRepo);
        container.listen(cryptoNotifierProvider, (_, __) {});
        await container.read(cryptoNotifierProvider.future);

        expect(container.read(cryptoNotifierProvider).value!.length, 1);

        when(() => mockRepo.getCryptos()).thenAnswer((_) async => const Success(CryptosResponse(cryptos: [tCoin, tCoin2], isFromCache: false)));

        await container.read(cryptoNotifierProvider.notifier).refresh();

        final state = container.read(cryptoNotifierProvider).value!;
        expect(state.length, 2);
      });
    });
  });
}
