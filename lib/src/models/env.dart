import 'package:envied/envied.dart';

part 'env.g.dart';

// TODO: 환경에 따른 환경변수 파일 경로 수정
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_CLIENT_ID', obfuscate: true)
  static String googleClientId = _Env.googleClientId;

  @EnviedField(varName: 'SERVER_BASE_URL', obfuscate: true)
  static String serverBaseUrl = _Env.serverBaseUrl;

  @EnviedField(varName: 'AppStoreAPI_KEY', obfuscate: true)
  static final String appStoreApiKey = _Env.appStoreApiKey;
}
