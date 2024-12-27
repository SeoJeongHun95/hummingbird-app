import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../models/token_model.dart';

part 'token_box_provider.g.dart';

@Riverpod(keepAlive: true)
Box<TokenModel> tokenBox(Ref ref) {
  final box = Hive.box<TokenModel>(BoxKeys.tokenBoxKey);

  return box;
}
