import 'package:equatable/equatable.dart';

class CryptoEntity extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;

  const CryptoEntity({required this.id, required this.symbol, required this.name, required this.imageUrl, required this.currentPrice});

  @override
  List<Object?> get props => [id, symbol, name, imageUrl, currentPrice];
}
