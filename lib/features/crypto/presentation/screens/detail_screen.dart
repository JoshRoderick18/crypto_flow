import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:crypto_flow/features/crypto/presentation/widgets/crypto_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  final CryptoEntity coin;

  const DetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final favorites = ref.watch(favoritesNotifierProvider);
    final isFavorite = favorites.contains(coin.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: colorScheme.surface.withOpacity(0.8),
            child: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorScheme.primaryContainer.withOpacity(0.3), colorScheme.surface]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Hero(
                  tag: coin.id,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surface,
                      boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                    ),
                    child: CryptoImage(imageUrl: coin.imageUrl, size: 100),
                  ),
                ),
                const SizedBox(height: 32),
                Text(coin.name, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    coin.symbol.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer, letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(height: 40),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text('Precio Actual', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                        const SizedBox(height: 8),
                        Text(
                          '\$${coin.currentPrice.toStringAsFixed(2)}',
                          style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatChip(context, icon: Icons.trending_up_rounded, label: '24h', color: Colors.green),
                            const SizedBox(width: 12),
                            _buildStatChip(context, icon: Icons.bar_chart_rounded, label: 'Vol', color: colorScheme.secondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: isFavorite
                        ? OutlinedButton.icon(
                            onPressed: () {
                              ref.read(favoritesNotifierProvider.notifier).toggleFavorite(coin.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.star_border_rounded, color: Colors.white),
                                      const SizedBox(width: 12),
                                      Text('${coin.name} eliminado de favoritos'),
                                    ],
                                  ),
                                  backgroundColor: colorScheme.secondary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.star_rounded, color: Colors.amber),
                            label: const Text('En Favoritos'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              side: BorderSide(color: Colors.amber, width: 2),
                            ),
                          )
                        : FilledButton.icon(
                            onPressed: () {
                              ref.read(favoritesNotifierProvider.notifier).toggleFavorite(coin.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber),
                                      const SizedBox(width: 12),
                                      Text('${coin.name} añadido a favoritos'),
                                    ],
                                  ),
                                  backgroundColor: colorScheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.star_border_rounded),
                            label: const Text('Añadir a Favoritos'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
