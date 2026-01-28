import 'package:crypto_flow/features/crypto/domain/entities/crypto_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_model.freezed.dart';
part 'crypto_model.g.dart';

@freezed
class CryptoModel with _$CryptoModel {
  const factory CryptoModel({
    required String id,
    required String symbol,
    required String name,
    @JsonKey(name: 'image') required String imageUrl,
    @JsonKey(name: 'current_price') required double currentPrice,
  }) = _CryptoModel;

  factory CryptoModel.fromJson(Map<String, dynamic> json) => _$CryptoModelFromJson(json);
}

extension CryptoModelX on CryptoModel {
  CryptoEntity toEntity() => CryptoEntity(id: id, symbol: symbol, name: name, imageUrl: imageUrl, currentPrice: currentPrice);
}
