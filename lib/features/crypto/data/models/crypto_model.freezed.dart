// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypto_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CryptoModel _$CryptoModelFromJson(Map<String, dynamic> json) {
  return _CryptoModel.fromJson(json);
}

/// @nodoc
mixin _$CryptoModel {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_price')
  double get currentPrice => throw _privateConstructorUsedError;

  /// Serializes this CryptoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CryptoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CryptoModelCopyWith<CryptoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CryptoModelCopyWith<$Res> {
  factory $CryptoModelCopyWith(
    CryptoModel value,
    $Res Function(CryptoModel) then,
  ) = _$CryptoModelCopyWithImpl<$Res, CryptoModel>;
  @useResult
  $Res call({
    String id,
    String symbol,
    String name,
    @JsonKey(name: 'image') String imageUrl,
    @JsonKey(name: 'current_price') double currentPrice,
  });
}

/// @nodoc
class _$CryptoModelCopyWithImpl<$Res, $Val extends CryptoModel>
    implements $CryptoModelCopyWith<$Res> {
  _$CryptoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CryptoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? currentPrice = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            symbol: null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPrice: null == currentPrice
                ? _value.currentPrice
                : currentPrice // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CryptoModelImplCopyWith<$Res>
    implements $CryptoModelCopyWith<$Res> {
  factory _$$CryptoModelImplCopyWith(
    _$CryptoModelImpl value,
    $Res Function(_$CryptoModelImpl) then,
  ) = __$$CryptoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String symbol,
    String name,
    @JsonKey(name: 'image') String imageUrl,
    @JsonKey(name: 'current_price') double currentPrice,
  });
}

/// @nodoc
class __$$CryptoModelImplCopyWithImpl<$Res>
    extends _$CryptoModelCopyWithImpl<$Res, _$CryptoModelImpl>
    implements _$$CryptoModelImplCopyWith<$Res> {
  __$$CryptoModelImplCopyWithImpl(
    _$CryptoModelImpl _value,
    $Res Function(_$CryptoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CryptoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? currentPrice = null,
  }) {
    return _then(
      _$CryptoModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        symbol: null == symbol
            ? _value.symbol
            : symbol // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPrice: null == currentPrice
            ? _value.currentPrice
            : currentPrice // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CryptoModelImpl extends _CryptoModel {
  const _$CryptoModelImpl({
    required this.id,
    required this.symbol,
    required this.name,
    @JsonKey(name: 'image') required this.imageUrl,
    @JsonKey(name: 'current_price') required this.currentPrice,
  }) : super._();

  factory _$CryptoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CryptoModelImplFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  final String name;
  @override
  @JsonKey(name: 'image')
  final String imageUrl;
  @override
  @JsonKey(name: 'current_price')
  final double currentPrice;

  @override
  String toString() {
    return 'CryptoModel(id: $id, symbol: $symbol, name: $name, imageUrl: $imageUrl, currentPrice: $currentPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CryptoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, symbol, name, imageUrl, currentPrice);

  /// Create a copy of CryptoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CryptoModelImplCopyWith<_$CryptoModelImpl> get copyWith =>
      __$$CryptoModelImplCopyWithImpl<_$CryptoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CryptoModelImplToJson(this);
  }
}

abstract class _CryptoModel extends CryptoModel {
  const factory _CryptoModel({
    required final String id,
    required final String symbol,
    required final String name,
    @JsonKey(name: 'image') required final String imageUrl,
    @JsonKey(name: 'current_price') required final double currentPrice,
  }) = _$CryptoModelImpl;
  const _CryptoModel._() : super._();

  factory _CryptoModel.fromJson(Map<String, dynamic> json) =
      _$CryptoModelImpl.fromJson;

  @override
  String get id;
  @override
  String get symbol;
  @override
  String get name;
  @override
  @JsonKey(name: 'image')
  String get imageUrl;
  @override
  @JsonKey(name: 'current_price')
  double get currentPrice;

  /// Create a copy of CryptoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CryptoModelImplCopyWith<_$CryptoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
