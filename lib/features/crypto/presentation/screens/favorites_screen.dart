import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:crypto_flow/features/crypto/presentation/widgets/crypto_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoNotifierProvider);
    final favorites = ref.watch(favoritesNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 28),
            SizedBox(width: 8),
            Text('Favoritos', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: cryptoAsync.when(
        data: (cryptos) {
          final favoriteCryptos = cryptos.where((c) => favorites.contains(c.id)).toList();

          if (favoriteCryptos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border_rounded, size: 80, color: colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No tienes favoritos', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colorScheme.outline)),
                  const SizedBox(height: 8),
                  Text(
                    'Añade criptomonedas a tus favoritos\ndesde la pantalla de detalles',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorScheme.outline),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.tonalIcon(onPressed: () => context.go('/'), icon: const Icon(Icons.explore_rounded), label: const Text('Explorar criptomonedas')),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteCryptos.length,
            itemBuilder: (_, i) {
              final coin = favoriteCryptos[i];
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
                            tag: 'fav_${coin.id}',
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
                              IconButton(
                                icon: Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                                onPressed: () {
                                  ref.read(favoritesNotifierProvider.notifier).toggleFavorite(coin.id);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
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
        error: (err, _) => Center(child: Text('Error al cargar favoritos')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
