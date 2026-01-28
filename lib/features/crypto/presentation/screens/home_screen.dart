import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:crypto_flow/features/crypto/presentation/widgets/crypto_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoNotifierProvider);

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

    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Flow')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Buscar Criptomoneda', hintText: 'Ej: Bitcoin', border: OutlineInputBorder(), prefixIcon: Icon(Icons.search)),
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
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: cryptos.length,
                    itemBuilder: (_, i) {
                      final coin = cryptos[i];
                      return ListTile(
                        leading: CryptoImage(imageUrl: coin.imageUrl),
                        title: Text(coin.name),
                        subtitle: Text(coin.symbol.toUpperCase()),
                        trailing: Text('\$${coin.currentPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                loading: () => const Center(child: CircularProgressIndicator()),
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
