import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'asdf.freezed.dart';
part 'asdf.g.dart';

@HiveType(typeId: 0)
@freezed
class Asdf with _$Asdf {
  factory Asdf({
    @HiveField(0) required final String a,
    @HiveField(1) required final int b,
    @HiveField(2) required final int c,
  }) = _Asdf;
}
