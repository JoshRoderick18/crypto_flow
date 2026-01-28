import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Coin Vault')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Buscar Criptomoneda', border: OutlineInputBorder(), prefixIcon: Icon(Icons.search)),
              onChanged: (val) => ref.read(cryptoNotifierProvider.notifier).search(val),
            ),
          ),
          Expanded(
            child: cryptoAsync.when(
              data: (cryptos) {
                if (cryptos.isEmpty) return const Center(child: Text('Sin resultados'));
                return ListView.builder(
                  itemCount: cryptos.length,
                  itemBuilder: (_, i) {
                    final coin = cryptos[i];
                    return ListTile(leading: Image.network(coin.imageUrl, width: 40), title: Text(coin.name), subtitle: Text(coin.symbol.toUpperCase()), trailing: Text('\$${coin.currentPrice}'));
                  },
                );
              },
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $err'),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: () => ref.read(cryptoNotifierProvider.notifier).refresh(), child: const Text('Reintentar')),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
