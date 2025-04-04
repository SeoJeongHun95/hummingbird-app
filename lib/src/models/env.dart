import 'package:envied/envied.dart';

part 'env.g.dart';

// TODO: 환경에 따른 환경변수 파일 경로 수정
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_CLIENT_ID', obfuscate: true)
  static String googleClientId = _Env.googleClientId;

  @EnviedField(varName: 'SERVER_BASE_URL', obfuscate: true)
  static String serverBaseUrl = _Env.serverBaseUrl;

  @EnviedField(varName: 'APPSTORE_API_KEY', obfuscate: true)
  static String appStoreApiKey = _Env.appStoreApiKey;

  // Android 실제 광고 ID
  @EnviedField(varName: 'ANDROID_BANNER_AD_ID', obfuscate: true)
  static String androidBannerAdId = _Env.androidBannerAdId;

  @EnviedField(varName: 'ANDROID_INTERSTITIAL_AD_ID', obfuscate: true)
  static String androidInterstitialAdId = _Env.androidInterstitialAdId;

  @EnviedField(varName: 'ANDROID_NATIVE_AD_ID', obfuscate: true)
  static String androidNativeAdId = _Env.androidNativeAdId;

  // iOS 실제 광고 ID
  @EnviedField(varName: 'IOS_BANNER_AD_ID', obfuscate: true)
  static String iosBannerAdId = _Env.iosBannerAdId;

  @EnviedField(varName: 'IOS_INTERSTITIAL_AD_ID', obfuscate: true)
  static String iosInterstitialAdId = _Env.iosInterstitialAdId;

  @EnviedField(varName: 'IOS_NATIVE_AD_ID', obfuscate: true)
  static String iosNativeAdId = _Env.iosNativeAdId;
}
