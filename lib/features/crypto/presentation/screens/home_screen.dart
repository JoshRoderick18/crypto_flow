import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:crypto_flow/features/crypto/presentation/widgets/crypto_image.dart';
import 'package:crypto_flow/features/crypto/presentation/widgets/loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    final favorites = ref.watch(favoritesNotifierProvider);

    ref.listen(cryptoNotifierProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_mapErrorToMessage(next.error!), style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent,
            action: SnackBarAction(label: 'Reintentar', textColor: Colors.white, onPressed: () => ref.read(cryptoNotifierProvider.notifier).refresh()),
          ),
        );
      }
    });

    ref.listen(globalMessageProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(next, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(globalMessageProvider.notifier).state = null;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.currency_bitcoin, size: 28),
            SizedBox(width: 8),
            Text('Crypto Flow', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.star_rounded), onPressed: () => context.go('/favorites')),
              if (favorites.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${favorites.length}',
                      style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(turns: animation, child: child),
              child: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode, key: ValueKey(themeMode)),
            ),
            onPressed: () {
              final currentMode = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              decoration: InputDecoration(hintText: 'Buscar criptomoneda...', prefixIcon: const Icon(Icons.search_rounded)),
              onChanged: (val) => ref.read(cryptoNotifierProvider.notifier).search(val),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(cryptoNotifierProvider.notifier).refresh(),
              child: cryptoAsync.when(
                data: (cryptos) {
                  if (cryptos.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 50),
                        Center(child: Text('No se encontraron resultados')),
                      ],
                    );
                  }
                  final sortedCryptos = [...cryptos]
                    ..sort((a, b) {
                      final aFav = favorites.contains(a.id) ? 0 : 1;
                      final bFav = favorites.contains(b.id) ? 0 : 1;
                      return aFav.compareTo(bFav);
                    });
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedCryptos.length,
                    itemBuilder: (_, i) {
                      final coin = sortedCryptos[i];
                      final colorScheme = Theme.of(context).colorScheme;
                      final isFavorite = favorites.contains(coin.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => context.go('/details', extra: coin),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: coin.id,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                                      ),
                                      child: CryptoImage(imageUrl: coin.imageUrl, size: 50),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(coin.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(6)),
                                          child: Text(
                                            coin.symbol.toUpperCase(),
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${coin.currentPrice.toStringAsFixed(2)}',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isFavorite)
                                            GestureDetector(
                                              onTap: () => ref.read(favoritesNotifierProvider.notifier).toggleFavorite(coin.id),
                                              child: const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                                            )
                                          else
                                            const SizedBox(width: 18),
                                          const SizedBox(width: 4),
                                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colorScheme.outline),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 50, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(_mapErrorToMessage(err), textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: () => ref.read(cryptoNotifierProvider.notifier).refresh(), child: const Text('Cargar de nuevo')),
                    ],
                  ),
                ),
                loading: () => const LoadingSkeleton(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _mapErrorToMessage(Object error) {
    final str = error.toString().toLowerCase();
    if (str.contains('socket') || str.contains('network')) {
      return 'Sin conexión a internet. Mostrando datos offline.';
    }
    if (str.contains('429')) {
      return 'Demasiadas peticiones. Espera un momento.';
    }
    return 'Ocurrió un error inesperado.';
  }
}
