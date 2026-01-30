import 'package:crypto_flow/core/router/app_router.dart';
import 'package:crypto_flow/features/crypto/presentation/providers/crypto_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  final box = await Hive.openBox('crypto_box');
  final favoritesBox = await Hive.openBox('favorites_box');

  runApp(ProviderScope(overrides: [cryptoBoxProvider.overrideWithValue(box), favoritesBoxProvider.overrideWithValue(favoritesBox)], child: const CryptoFlowApp()));
}

class CryptoFlowApp extends ConsumerWidget {
  const CryptoFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Crypto Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.light),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardThemeData(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardThemeData(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
