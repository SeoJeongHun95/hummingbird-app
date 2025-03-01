import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../src/models/env.dart';

class AdMobWidget {
  static String? anchoredAdaptiveBannerAdUnitId() {
    if (Platform.isAndroid) {
      return Env.androidTestAdId; // Android 배너 테스트 ID Env.androidTestAdId;
    } else if (Platform.isIOS) {
      return Env.iosTestAdId; // iOS 배너 테스트 ID
    }
    return null;
  }

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

  static Widget showBannerAd(double height) {
    final adUnitId = anchoredAdaptiveBannerAdUnitId();
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
                  ScreenUtil().screenWidth.toInt(),
                  height.h.toInt())), // Android에서는 고정된 배너 크기 사용
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            return SizedBox(
              width: ScreenUtil().screenWidth,
              height: height.h, // height를 설정하여 광고 배너가 적절히 표시되도록 함
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
}

//height 값 필수
//AdMobWidget.showBannerAd(50),
