# 💰 Crypto Flow

App de criptomonedas con arquitectura **Offline-First**. Muestra precios en tiempo real y funciona sin conexión gracias al caché local.

## ✨ Características

- 📊 Listado de criptomonedas con precios actuales
- 🔍 Búsqueda instantánea con debounce
- ⭐ Sistema de favoritos persistente
- 🌙 Modo claro/oscuro
- 📱 Funciona offline (datos cacheados)
- 🎯 Manejo de errores tipado (Result pattern)

## 🏗️ Arquitectura

```
lib/
├── core/                 # Utilidades compartidas
│   ├── error/            # Tipos de errores (Failures)
│   ├── result/           # Result<T, E> sealed class
│   └── router/           # GoRouter config
│
└── features/crypto/
    ├── domain/           # Entities, UseCases, Repository interface
    ├── data/             # Models, DataSources, Repository impl
    └── presentation/     # Screens, Widgets, State, Providers
```

## 🛠️ Stack Técnico

| Categoría | Tecnología |
|-----------|------------|
| Framework | Flutter 3 + Dart 3 |
| Arquitectura | Clean Architecture |
| Estado | Riverpod 2.0 (AsyncNotifier) |
| Navegación | GoRouter |
| HTTP | Dio |
| Caché | Hive |
| Modelos | Freezed + json_serializable |
| Testing | flutter_test + mocktail |

## 🚀 Instalación

```bash
# Clonar
git clone https://github.com/tu-usuario/crypto_flow.git

# Instalar dependencias
flutter pub get

# Crear archivo .env con tu API key
echo "COINGECKO_API_KEY=tu_key" > .env

# Generar código (Freezed)
dart run build_runner build

# Ejecutar
flutter run
```

## 🧪 Tests

```bash
flutter test                    # Ejecutar tests
flutter test --coverage         # Con cobertura
```

## 📄 Licencia

MIT
