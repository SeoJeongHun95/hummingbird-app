import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/const/box_keys.dart';
import '../models/token_model.dart';
import 'boxes/token_box_provider.dart';

part 'token_provider.g.dart';

class TokenProvider {
  final Box<TokenModel> storage;

  TokenProvider({required this.storage});

  TokenModel? getToken() {
    return storage.get(BoxKeys.tokenBoxKey);
  }

  void updateToken(TokenModel tokens) {
    storage.put(BoxKeys.tokenBoxKey, tokens);
  }

  void deleteToken() {
    storage.delete(BoxKeys.tokenBoxKey);
  }
}

@Riverpod(keepAlive: true)
TokenProvider token(Ref ref) {
  final storage = ref.watch(tokenBoxProvider);

  return TokenProvider(storage: storage);
}
