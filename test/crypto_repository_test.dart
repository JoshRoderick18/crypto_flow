import 'package:crypto_flow/features/crypto/data/datasources/crypto_local_data_source.dart';
import 'package:crypto_flow/features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'package:crypto_flow/features/crypto/data/models/crypto_model.dart';
import 'package:crypto_flow/features/crypto/data/repositories/crypto_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements CryptoRemoteDataSource {}

class MockLocal extends Mock implements CryptoLocalDataSource {}

void main() {
  late CryptoRepositoryImpl repo;
  late MockRemote mockRemote;
  late MockLocal mockLocal;

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    repo = CryptoRepositoryImpl(mockRemote, mockLocal);
  });

  test('Debe usar datos locales si falla el remoto', () async {
    when(() => mockRemote.getAll()).thenThrow(Exception());
    when(() => mockLocal.getLastCryptos()).thenAnswer((_) async => [const CryptoModel(id: '1', symbol: 'x', name: 'x', imageUrl: 'x', currentPrice: 1)]);

    final (cryptos, isOffline) = await repo.getCryptos();

    expect(cryptos.length, 1);
    expect(isOffline, true);
    verify(() => mockLocal.getLastCryptos()).called(1);
  });
}
