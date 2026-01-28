import 'dart:async';

import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CryptoNotifier extends AutoDisposeAsyncNotifier<List<CryptoEntity>> {
  List<CryptoEntity> _fullList = [];
  Timer? _debounceTimer;

  @override
  Future<List<CryptoEntity>> build() async {
    ref.onDispose(() => _debounceTimer?.cancel());

    final repository = ref.read(cryptoRepositoryProvider);

    final (cryptos, isOffline) = await repository.getCryptos();
    _fullList = cryptos;

    if (isOffline) {
      Future.microtask(() {
        ref.read(globalMessageProvider.notifier).state = 'Sin conexión a internet. Mostrando datos offline.';
      });
    }

    return _fullList;
  }

  void search(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        state = AsyncValue.data(_fullList);
        return;
      }

      final filtered = _fullList.where((coin) {
        return coin.name.toLowerCase().contains(query.toLowerCase()) || coin.symbol.toLowerCase().contains(query.toLowerCase());
      }).toList();

      state = AsyncValue.data(filtered);
    });
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
