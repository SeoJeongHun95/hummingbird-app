// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asdf.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Asdf {
  @HiveField(0)
  String get a => throw _privateConstructorUsedError;
  @HiveField(1)
  int get b => throw _privateConstructorUsedError;
  @HiveField(2)
  int get c => throw _privateConstructorUsedError;

  /// Create a copy of Asdf
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AsdfCopyWith<Asdf> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsdfCopyWith<$Res> {
  factory $AsdfCopyWith(Asdf value, $Res Function(Asdf) then) =
      _$AsdfCopyWithImpl<$Res, Asdf>;
  @useResult
  $Res call({@HiveField(0) String a, @HiveField(1) int b, @HiveField(2) int c});
}

/// @nodoc
class _$AsdfCopyWithImpl<$Res, $Val extends Asdf>
    implements $AsdfCopyWith<$Res> {
  _$AsdfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Asdf
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
    Object? c = null,
  }) {
    return _then(_value.copyWith(
      a: null == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as String,
      b: null == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as int,
      c: null == c
          ? _value.c
          : c // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AsdfImplCopyWith<$Res> implements $AsdfCopyWith<$Res> {
  factory _$$AsdfImplCopyWith(
          _$AsdfImpl value, $Res Function(_$AsdfImpl) then) =
      __$$AsdfImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) String a, @HiveField(1) int b, @HiveField(2) int c});
}

/// @nodoc
class __$$AsdfImplCopyWithImpl<$Res>
    extends _$AsdfCopyWithImpl<$Res, _$AsdfImpl>
    implements _$$AsdfImplCopyWith<$Res> {
  __$$AsdfImplCopyWithImpl(_$AsdfImpl _value, $Res Function(_$AsdfImpl) _then)
      : super(_value, _then);

  /// Create a copy of Asdf
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
    Object? c = null,
  }) {
    return _then(_$AsdfImpl(
      a: null == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as String,
      b: null == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as int,
      c: null == c
          ? _value.c
          : c // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AsdfImpl implements _Asdf {
  _$AsdfImpl(
      {@HiveField(0) required this.a,
      @HiveField(1) required this.b,
      @HiveField(2) required this.c});

  @override
  @HiveField(0)
  final String a;
  @override
  @HiveField(1)
  final int b;
  @override
  @HiveField(2)
  final int c;

  @override
  String toString() {
    return 'Asdf(a: $a, b: $b, c: $c)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsdfImpl &&
            (identical(other.a, a) || other.a == a) &&
            (identical(other.b, b) || other.b == b) &&
            (identical(other.c, c) || other.c == c));
  }

  @override
  int get hashCode => Object.hash(runtimeType, a, b, c);

  /// Create a copy of Asdf
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsdfImplCopyWith<_$AsdfImpl> get copyWith =>
      __$$AsdfImplCopyWithImpl<_$AsdfImpl>(this, _$identity);
}

abstract class _Asdf implements Asdf {
  factory _Asdf(
      {@HiveField(0) required final String a,
      @HiveField(1) required final int b,
      @HiveField(2) required final int c}) = _$AsdfImpl;

  @override
  @HiveField(0)
  String get a;
  @override
  @HiveField(1)
  int get b;
  @override
  @HiveField(2)
  int get c;

  /// Create a copy of Asdf
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsdfImplCopyWith<_$AsdfImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
