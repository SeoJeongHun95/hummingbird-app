import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_CLIENT_ID', obfuscate: true)
  static String googleClientId = _Env.googleClientId;

  @EnviedField(varName: 'SERVER_BASE_URL', obfuscate: true)
  static String serverBaseUrl = _Env.serverBaseUrl;
}
