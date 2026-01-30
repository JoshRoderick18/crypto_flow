import 'package:equatable/equatable.dart';

sealed class AppFailure extends Equatable {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppFailure({required this.message, this.code, this.stackTrace});

  @override
  List<Object?> get props => [message, code];
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure({super.message = 'Error de conexión a internet', super.code, super.stackTrace});
}

final class ServerFailure extends AppFailure {
  final int? statusCode;

  const ServerFailure({super.message = 'Error del servidor', super.code, super.stackTrace, this.statusCode});

  @override
  List<Object?> get props => [...super.props, statusCode];
}

final class RateLimitFailure extends AppFailure {
  final Duration? retryAfter;

  const RateLimitFailure({super.message = 'Demasiadas peticiones. Intenta más tarde.', super.code = '429', super.stackTrace, this.retryAfter});

  @override
  List<Object?> get props => [...super.props, retryAfter];
}

final class CacheFailure extends AppFailure {
  const CacheFailure({super.message = 'Error al acceder a datos locales', super.code, super.stackTrace});
}

final class NoDataFailure extends AppFailure {
  const NoDataFailure({super.message = 'No hay datos disponibles', super.code, super.stackTrace});
}

final class UnknownFailure extends AppFailure {
  final Object? originalError;

  const UnknownFailure({super.message = 'Ocurrió un error inesperado', super.code, super.stackTrace, this.originalError});

  @override
  List<Object?> get props => [...super.props, originalError];
}
