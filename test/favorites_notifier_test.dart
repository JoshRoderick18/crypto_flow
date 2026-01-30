import 'package:crypto_flow/features/crypto/presentation/state/favorites_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box {}

void main() {
  late FavoritesNotifier notifier;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    when(() => mockBox.get('favorites', defaultValue: <dynamic>[])).thenReturn(<dynamic>[]);
  });

  group('FavoritesNotifier -', () {
    test('Debe iniciar con estado vacío', () {
      notifier = FavoritesNotifier(mockBox);

      expect(notifier.state, isEmpty);
    });

    test('Debe cargar favoritos existentes del box', () {
      when(() => mockBox.get('favorites', defaultValue: <dynamic>[])).thenReturn(<dynamic>['btc', 'eth']);

      notifier = FavoritesNotifier(mockBox);

      expect(notifier.state.length, 2);
      expect(notifier.state.contains('btc'), true);
      expect(notifier.state.contains('eth'), true);
    });

    group('isFavorite -', () {
      test('Debe retornar true si es favorito', () {
        when(() => mockBox.get('favorites', defaultValue: <dynamic>[])).thenReturn(<dynamic>['btc']);

        notifier = FavoritesNotifier(mockBox);

        expect(notifier.isFavorite('btc'), true);
      });

      test('Debe retornar false si no es favorito', () {
        notifier = FavoritesNotifier(mockBox);

        expect(notifier.isFavorite('xyz'), false);
      });
    });

    group('toggleFavorite -', () {
      test('Debe agregar favorito si no existe', () async {
        when(() => mockBox.put('favorites', any())).thenAnswer((_) async {});
        notifier = FavoritesNotifier(mockBox);

        await notifier.toggleFavorite('btc');

        expect(notifier.state.contains('btc'), true);
        verify(() => mockBox.put('favorites', ['btc'])).called(1);
      });

      test('Debe eliminar favorito si ya existe', () async {
        when(() => mockBox.get('favorites', defaultValue: <dynamic>[])).thenReturn(<dynamic>['btc']);
        when(() => mockBox.put('favorites', any())).thenAnswer((_) async {});
        notifier = FavoritesNotifier(mockBox);

        expect(notifier.state.contains('btc'), true);

        await notifier.toggleFavorite('btc');

        expect(notifier.state.contains('btc'), false);
        verify(() => mockBox.put('favorites', [])).called(1);
      });
    });

    group('addFavorite -', () {
      test('Debe agregar favorito', () async {
        when(() => mockBox.put('favorites', any())).thenAnswer((_) async {});
        notifier = FavoritesNotifier(mockBox);

        await notifier.addFavorite('btc');

        expect(notifier.state.contains('btc'), true);
      });

      test('No debe duplicar favorito existente', () async {
        when(() => mockBox.get('favorites', defaultValue: <dynamic>[])).thenReturn(<dynamic>['btc']);
        when(() => mockBox.put('favorites', any())).thenAnswer((_) async {});
        notifier = FavoritesNotifier(mockBox);

        await notifier.addFavorite('btc');

        expect(notifier.state.length, 1);
        verifyNever(() => mockBox.put('favorites', any()));
      });
    });

    group('removeFavorite -', () {
      test('Debe eliminar favorito existente', () async {
        when(() => mockBox.get('favorites', defaultValue: <dynamic>[])).thenReturn(<dynamic>['btc', 'eth']);
        when(() => mockBox.put('favorites', any())).thenAnswer((_) async {});
        notifier = FavoritesNotifier(mockBox);

        await notifier.removeFavorite('btc');

        expect(notifier.state.contains('btc'), false);
        expect(notifier.state.contains('eth'), true);
      });

      test('No debe hacer nada si no existe', () async {
        notifier = FavoritesNotifier(mockBox);

        await notifier.removeFavorite('xyz');

        verifyNever(() => mockBox.put('favorites', any()));
      });
    });

    group('Persistencia -', () {
      test('Debe guardar en box al agregar', () async {
        when(() => mockBox.put('favorites', any())).thenAnswer((_) async {});
        notifier = FavoritesNotifier(mockBox);

        await notifier.addFavorite('btc');
        await notifier.addFavorite('eth');

        verify(() => mockBox.put('favorites', any())).called(2);
      });

      test('Debe guardar en box al eliminar', () async {
        when(() => mockBox.get('favorites', defaultValue: <dynamic>[])).thenReturn(<dynamic>['btc']);
        when(() => mockBox.put('favorites', any())).thenAnswer((_) async {});
        notifier = FavoritesNotifier(mockBox);

        await notifier.removeFavorite('btc');

        verify(() => mockBox.put('favorites', [])).called(1);
      });
    });
  });
}
