// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_login_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoogleLoginApiRequestImpl _$$GoogleLoginApiRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GoogleLoginApiRequestImpl(
      googleId: json['googleId'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$$GoogleLoginApiRequestImplToJson(
        _$GoogleLoginApiRequestImpl instance) =>
    <String, dynamic>{
      'googleId': instance.googleId,
      'email': instance.email,
      'nickname': instance.nickname,
      'thumbnailUrl': instance.thumbnailUrl,
    };

_$GoogleLoginApiResponseImpl _$$GoogleLoginApiResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GoogleLoginApiResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenExpiresAtInSeconds: (json['tokenExpiresAtInSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$$GoogleLoginApiResponseImplToJson(
        _$GoogleLoginApiResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenExpiresAtInSeconds': instance.tokenExpiresAtInSeconds,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$googleLoginApiHash() => r'8e82b06ca60e4b500479439a83d8c7f072b0443a';

/// See also [googleLoginApi].
@ProviderFor(googleLoginApi)
final googleLoginApiProvider = AutoDisposeProvider<GoogleLoginApi>.internal(
  googleLoginApi,
  name: r'googleLoginApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleLoginApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoogleLoginApiRef = AutoDisposeProviderRef<GoogleLoginApi>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
