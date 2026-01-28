import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements CryptoRepository {}

void main() {
  late MockRepo mockRepo;

  setUp(() {
    mockRepo = MockRepo();
  });

  ProviderContainer makeProviderContainer(MockRepo repo) {
    return ProviderContainer(overrides: [cryptoRepositoryProvider.overrideWithValue(repo)]);
  }

  final tCoin = const CryptoEntity(id: '1', symbol: 'btc', name: 'Bitcoin', imageUrl: '', currentPrice: 100);

  test('Debe cargar la lista inicial correctamente', () async {
    when(() => mockRepo.getCryptos()).thenAnswer((_) async => ([tCoin], false));
    final container = makeProviderContainer(mockRepo);

    final sub = container.listen(cryptoNotifierProvider, (_, __) {});

    await container.read(cryptoNotifierProvider.future);

    expect(container.read(cryptoNotifierProvider).value, equals([tCoin]));
  });

  test('Search debe filtrar la lista', () async {
    final tCoin2 = const CryptoEntity(id: '2', symbol: 'eth', name: 'Ethereum', imageUrl: '', currentPrice: 50);
    when(() => mockRepo.getCryptos()).thenAnswer((_) async => ([tCoin, tCoin2], false));

    final container = makeProviderContainer(mockRepo);
    final sub = container.listen(cryptoNotifierProvider, (_, __) {});
    await container.read(cryptoNotifierProvider.future);

    container.read(cryptoNotifierProvider.notifier).search('Bit');

    await Future.delayed(const Duration(milliseconds: 600));

    final state = container.read(cryptoNotifierProvider).value!;
    expect(state.length, 1);
    expect(state.first.name, 'Bitcoin');
  });
}
