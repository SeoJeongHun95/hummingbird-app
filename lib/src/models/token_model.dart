import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'token_model.freezed.dart';
part 'token_model.g.dart';

@freezed
class TokenModel with _$TokenModel {
  @HiveType(typeId: 1, adapterName: 'TokenModelAdapter')
  const factory TokenModel({
    @HiveField(0, defaultValue: null) String? accessToken,
    @HiveField(1, defaultValue: null) String? refreshToken,
    @HiveField(2, defaultValue: null) int? expiresAt,
    @HiveField(3, defaultValue: null) int? userId,
  }) = _TokenModel;
}
