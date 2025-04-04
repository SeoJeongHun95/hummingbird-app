import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../src/models/env.dart';

class AdMobWidget {
  // 배너 광고 ID
  static String? bannerAdUnitId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-8655023098401674/7820188800";
      // return Env.androidBannerAdId; // 실제 앱에서는 실제 ID로 교체
    } else if (Platform.isIOS) {
      return "ca-app-pub-8655023098401674/5194025465"; // 테스트 ID
      // return Env.iosBannerAdId; // 실제 앱에서는 실제 ID로 교체
    }
    return null;
  }

  // 전면 광고 ID
  static String? interstitialAdUnitId() {
    if (Platform.isAndroid) {
      return Env.androidInterstitialAdId; // 실제 앱에서는 실제 ID로 교체
      // return "ca-app-pub-3940256099942544/1033173712"; // 테스트 ID
    } else if (Platform.isIOS) {
      return Env.iosInterstitialAdId; // 실제 앱에서는 실제 ID로 교체
      // return "ca-app-pub-3940256099942544/4411468910"; // 테스트 ID
    }
    return null;
  }

  // 네이티브 고급 광고 ID
  static String? nativeAdvancedAdUnitId() {
    if (Platform.isAndroid) {
      return Env.androidNativeAdId; // 실제 앱에서는 실제 ID로 교체
      // return "ca-app-pub-3940256099942544/2247696110"; // 테스트 ID
    } else if (Platform.isIOS) {
      return Env.iosNativeAdId; // 실제 앱에서는 실제 ID로 교체
      // return "ca-app-pub-3940256099942544/3986624511"; // 테스트 ID
    }
    return null;
  }

  // 배너 광고 생성
  static BannerAd getBannerAd({
    required String adUnitId,
    required AdSize size,
  }) {
    return BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('배너 광고가 성공적으로 로드되었습니다.');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('배너 광고 로드 실패: ${error.message}');
          debugPrint('에러 코드: ${error.code}');
          debugPrint('에러 도메인: ${error.domain}');
          ad.dispose();
        },
      ),
    )..load();
  }

  // 고정 높이의 배너 광고 표시
  static Widget showBannerAd(double height) {
    final adUnitId = bannerAdUnitId();
    if (adUnitId == null) {
      return const SizedBox.shrink();
    }

    return Builder(
      builder: (context) {
        return FutureBuilder<AdSize?>(
          future: Platform.isIOS
              ? AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
                  ScreenUtil().screenWidth.toInt(),
                )
              : Future.value(AdSize.getInlineAdaptiveBannerAdSize(
                  ScreenUtil().screenWidth.toInt(), height.h.toInt())),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            return SizedBox(
              width: ScreenUtil().screenWidth,
              height: height.h,
              child: AdWidget(
                ad: getBannerAd(
                  adUnitId: adUnitId,
                  size: snapshot.data!,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Expanded 버전의 배너 광고 위젯
  static Widget showExpandedBannerAd([double? height]) {
    final adUnitId = bannerAdUnitId();
    if (adUnitId == null) {
      return const SizedBox.shrink();
    }

    return Builder(
      builder: (context) {
        return Expanded(
          child: FutureBuilder<AdSize?>(
            future: Platform.isIOS
                ? AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
                    ScreenUtil().screenWidth.toInt(),
                  )
                : Future.value(AdSize.getInlineAdaptiveBannerAdSize(
                    ScreenUtil().screenWidth.toInt(),
                    height?.h.toInt() ?? ScreenUtil().screenHeight.toInt())),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              return SizedBox(
                width: ScreenUtil().screenWidth,
                height: height?.h ?? double.infinity,
                child: AdWidget(
                  ad: getBannerAd(
                    adUnitId: adUnitId,
                    size: snapshot.data!,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 네이티브 고급 광고
  static Widget showNativeAd({
    required double height,
    required String factoryId,
  }) {
    final adUnitId = nativeAdvancedAdUnitId();
    if (adUnitId == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height.h,
      child: FutureBuilder<NativeAd?>(
        future: _loadNativeAd(adUnitId, factoryId, height),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            height: height.h,
            width: double.infinity,
            child: AdWidget(ad: snapshot.data!),
          );
        },
      ),
    );
  }

  // 네이티브 광고 로드 - 고정된 크기 적용
  static Future<NativeAd?> _loadNativeAd(
    String adUnitId,
    String factoryId,
    double height,
  ) async {
    final completer = Completer<NativeAd?>();

    // 네이티브 광고 크기 - 안드로이드에서도 고정 크기 사용
    final adSize = Platform.isAndroid
        ? Size(ScreenUtil().screenWidth, height.h)
        : Size(ScreenUtil().screenWidth, height.h);

    final ad = NativeAd(
      adUnitId: adUnitId,
      factoryId: factoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('네이티브 광고가 성공적으로 로드되었습니다.');
          completer.complete(ad as NativeAd);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('네이티브 광고 로드 실패: ${error.message}');
          debugPrint('에러 코드: ${error.code}');
          debugPrint('에러 도메인: ${error.domain}');
          ad.dispose();
          completer.complete(null);
        },
      ),
      // 안드로이드에서 크기 문제 해결을 위한 옵션 추가
      customOptions: Platform.isAndroid
          ? {"adWidth": adSize.width.toInt(), "adHeight": adSize.height.toInt()}
          : null,
    );

    await ad.load();

    // 일정 시간이 지나도 로드되지 않으면 null 반환
    Future.delayed(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  // 전면 광고 로드 및 표시
  static Future<void> showInterstitialAd({Function? onAdClosed}) async {
    final adUnitId = interstitialAdUnitId();
    if (adUnitId == null) {
      onAdClosed?.call();
      return;
    }

    InterstitialAd? interstitialAd;
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('전면 광고가 성공적으로 로드되었습니다.');
          interstitialAd = ad;

          // 광고가 로드되면 표시
          if (interstitialAd != null) {
            interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('전면 광고가 닫혔습니다.');
                ad.dispose();
                onAdClosed?.call();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('전면 광고 표시 실패: ${error.message}');
                ad.dispose();
                onAdClosed?.call();
              },
            );
            interstitialAd!.show();
          } else {
            onAdClosed?.call();
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('전면 광고 로드 실패: ${error.message}');
          debugPrint('에러 코드: ${error.code}');
          debugPrint('에러 도메인: ${error.domain}');
          onAdClosed?.call();
        },
      ),
    );
  }
}

// 배너 광고 사용
// 고정 크기의 배너 광고 표시
// AdMobWidget.showBannerAd(50);

// 또는 확장되는 배너 광고 표시 (Expanded 내부에서 사용할 때)
// AdMobWidget.showExpandedBannerAd();



// 네이티브 고급 광고 사용
// factoryId는 네이티브 광고 레이아웃을 등록할 때 사용한 ID입니다
// AdMobWidget.showNativeAd(
//   height: 300,
//   factoryId: 'listTile',
// );



// 전면 광고 사용
// AdMobWidget.showInterstitialAd(
//   onAdClosed: () {
//     // 광고가 닫힌 후 실행할 코드
//     print('광고가 닫혔습니다');
//   },
// );