// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_login_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoogleLoginApiRequest _$GoogleLoginApiRequestFromJson(
    Map<String, dynamic> json) {
  return _GoogleLoginApiRequest.fromJson(json);
}

/// @nodoc
mixin _$GoogleLoginApiRequest {
  String get googleId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;

  /// Serializes this GoogleLoginApiRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoogleLoginApiRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoogleLoginApiRequestCopyWith<GoogleLoginApiRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleLoginApiRequestCopyWith<$Res> {
  factory $GoogleLoginApiRequestCopyWith(GoogleLoginApiRequest value,
          $Res Function(GoogleLoginApiRequest) then) =
      _$GoogleLoginApiRequestCopyWithImpl<$Res, GoogleLoginApiRequest>;
  @useResult
  $Res call(
      {String googleId, String email, String? nickname, String? thumbnailUrl});
}

/// @nodoc
class _$GoogleLoginApiRequestCopyWithImpl<$Res,
        $Val extends GoogleLoginApiRequest>
    implements $GoogleLoginApiRequestCopyWith<$Res> {
  _$GoogleLoginApiRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoogleLoginApiRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? googleId = null,
    Object? email = null,
    Object? nickname = freezed,
    Object? thumbnailUrl = freezed,
  }) {
    return _then(_value.copyWith(
      googleId: null == googleId
          ? _value.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleLoginApiRequestImplCopyWith<$Res>
    implements $GoogleLoginApiRequestCopyWith<$Res> {
  factory _$$GoogleLoginApiRequestImplCopyWith(
          _$GoogleLoginApiRequestImpl value,
          $Res Function(_$GoogleLoginApiRequestImpl) then) =
      __$$GoogleLoginApiRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String googleId, String email, String? nickname, String? thumbnailUrl});
}

/// @nodoc
class __$$GoogleLoginApiRequestImplCopyWithImpl<$Res>
    extends _$GoogleLoginApiRequestCopyWithImpl<$Res,
        _$GoogleLoginApiRequestImpl>
    implements _$$GoogleLoginApiRequestImplCopyWith<$Res> {
  __$$GoogleLoginApiRequestImplCopyWithImpl(_$GoogleLoginApiRequestImpl _value,
      $Res Function(_$GoogleLoginApiRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoogleLoginApiRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? googleId = null,
    Object? email = null,
    Object? nickname = freezed,
    Object? thumbnailUrl = freezed,
  }) {
    return _then(_$GoogleLoginApiRequestImpl(
      googleId: null == googleId
          ? _value.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleLoginApiRequestImpl implements _GoogleLoginApiRequest {
  const _$GoogleLoginApiRequestImpl(
      {required this.googleId,
      required this.email,
      this.nickname,
      this.thumbnailUrl});

  factory _$GoogleLoginApiRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleLoginApiRequestImplFromJson(json);

  @override
  final String googleId;
  @override
  final String email;
  @override
  final String? nickname;
  @override
  final String? thumbnailUrl;

  @override
  String toString() {
    return 'GoogleLoginApiRequest(googleId: $googleId, email: $email, nickname: $nickname, thumbnailUrl: $thumbnailUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleLoginApiRequestImpl &&
            (identical(other.googleId, googleId) ||
                other.googleId == googleId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, googleId, email, nickname, thumbnailUrl);

  /// Create a copy of GoogleLoginApiRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleLoginApiRequestImplCopyWith<_$GoogleLoginApiRequestImpl>
      get copyWith => __$$GoogleLoginApiRequestImplCopyWithImpl<
          _$GoogleLoginApiRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleLoginApiRequestImplToJson(
      this,
    );
  }
}

abstract class _GoogleLoginApiRequest implements GoogleLoginApiRequest {
  const factory _GoogleLoginApiRequest(
      {required final String googleId,
      required final String email,
      final String? nickname,
      final String? thumbnailUrl}) = _$GoogleLoginApiRequestImpl;

  factory _GoogleLoginApiRequest.fromJson(Map<String, dynamic> json) =
      _$GoogleLoginApiRequestImpl.fromJson;

  @override
  String get googleId;
  @override
  String get email;
  @override
  String? get nickname;
  @override
  String? get thumbnailUrl;

  /// Create a copy of GoogleLoginApiRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoogleLoginApiRequestImplCopyWith<_$GoogleLoginApiRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GoogleLoginApiResponse _$GoogleLoginApiResponseFromJson(
    Map<String, dynamic> json) {
  return _GoogleLoginApiResponse.fromJson(json);
}

/// @nodoc
mixin _$GoogleLoginApiResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  int get tokenExpiresAtInSeconds => throw _privateConstructorUsedError;

  /// Serializes this GoogleLoginApiResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoogleLoginApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoogleLoginApiResponseCopyWith<GoogleLoginApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleLoginApiResponseCopyWith<$Res> {
  factory $GoogleLoginApiResponseCopyWith(GoogleLoginApiResponse value,
          $Res Function(GoogleLoginApiResponse) then) =
      _$GoogleLoginApiResponseCopyWithImpl<$Res, GoogleLoginApiResponse>;
  @useResult
  $Res call(
      {String accessToken, String refreshToken, int tokenExpiresAtInSeconds});
}

/// @nodoc
class _$GoogleLoginApiResponseCopyWithImpl<$Res,
        $Val extends GoogleLoginApiResponse>
    implements $GoogleLoginApiResponseCopyWith<$Res> {
  _$GoogleLoginApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoogleLoginApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenExpiresAtInSeconds = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenExpiresAtInSeconds: null == tokenExpiresAtInSeconds
          ? _value.tokenExpiresAtInSeconds
          : tokenExpiresAtInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleLoginApiResponseImplCopyWith<$Res>
    implements $GoogleLoginApiResponseCopyWith<$Res> {
  factory _$$GoogleLoginApiResponseImplCopyWith(
          _$GoogleLoginApiResponseImpl value,
          $Res Function(_$GoogleLoginApiResponseImpl) then) =
      __$$GoogleLoginApiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken, String refreshToken, int tokenExpiresAtInSeconds});
}

/// @nodoc
class __$$GoogleLoginApiResponseImplCopyWithImpl<$Res>
    extends _$GoogleLoginApiResponseCopyWithImpl<$Res,
        _$GoogleLoginApiResponseImpl>
    implements _$$GoogleLoginApiResponseImplCopyWith<$Res> {
  __$$GoogleLoginApiResponseImplCopyWithImpl(
      _$GoogleLoginApiResponseImpl _value,
      $Res Function(_$GoogleLoginApiResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoogleLoginApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenExpiresAtInSeconds = null,
  }) {
    return _then(_$GoogleLoginApiResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenExpiresAtInSeconds: null == tokenExpiresAtInSeconds
          ? _value.tokenExpiresAtInSeconds
          : tokenExpiresAtInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleLoginApiResponseImpl implements _GoogleLoginApiResponse {
  const _$GoogleLoginApiResponseImpl(
      {required this.accessToken,
      required this.refreshToken,
      required this.tokenExpiresAtInSeconds});

  factory _$GoogleLoginApiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleLoginApiResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final int tokenExpiresAtInSeconds;

  @override
  String toString() {
    return 'GoogleLoginApiResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenExpiresAtInSeconds: $tokenExpiresAtInSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleLoginApiResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(
                    other.tokenExpiresAtInSeconds, tokenExpiresAtInSeconds) ||
                other.tokenExpiresAtInSeconds == tokenExpiresAtInSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, refreshToken, tokenExpiresAtInSeconds);

  /// Create a copy of GoogleLoginApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleLoginApiResponseImplCopyWith<_$GoogleLoginApiResponseImpl>
      get copyWith => __$$GoogleLoginApiResponseImplCopyWithImpl<
          _$GoogleLoginApiResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleLoginApiResponseImplToJson(
      this,
    );
  }
}

abstract class _GoogleLoginApiResponse implements GoogleLoginApiResponse {
  const factory _GoogleLoginApiResponse(
          {required final String accessToken,
          required final String refreshToken,
          required final int tokenExpiresAtInSeconds}) =
      _$GoogleLoginApiResponseImpl;

  factory _GoogleLoginApiResponse.fromJson(Map<String, dynamic> json) =
      _$GoogleLoginApiResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  int get tokenExpiresAtInSeconds;

  /// Create a copy of GoogleLoginApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoogleLoginApiResponseImplCopyWith<_$GoogleLoginApiResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
