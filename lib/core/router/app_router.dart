import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:crypto_flow/features/crypto/presentation/screens/detail_screen.dart';
import 'package:crypto_flow/features/crypto/presentation/screens/favorites_screen.dart';
import 'package:crypto_flow/features/crypto/presentation/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'details',
            builder: (context, state) {
              final coin = state.extra as CryptoEntity;
              return DetailScreen(coin: coin);
            },
          ),
          GoRoute(path: 'favorites', builder: (context, state) => const FavoritesScreen()),
        ],
      ),
    ],
  );
});
