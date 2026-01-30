import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final Box _box;
  static const String _favoritesKey = 'favorites';

  FavoritesNotifier(this._box) : super({}) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final List<dynamic> stored = _box.get(_favoritesKey, defaultValue: <dynamic>[]);
    state = stored.cast<String>().toSet();
  }

  Future<void> _saveFavorites() async {
    await _box.put(_favoritesKey, state.toList());
  }

  bool isFavorite(String coinId) => state.contains(coinId);

  Future<void> toggleFavorite(String coinId) async {
    if (state.contains(coinId)) {
      state = {...state}..remove(coinId);
    } else {
      state = {...state, coinId};
    }
    await _saveFavorites();
  }

  Future<void> addFavorite(String coinId) async {
    if (!state.contains(coinId)) {
      state = {...state, coinId};
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(String coinId) async {
    if (state.contains(coinId)) {
      state = {...state}..remove(coinId);
      await _saveFavorites();
    }
  }
}
