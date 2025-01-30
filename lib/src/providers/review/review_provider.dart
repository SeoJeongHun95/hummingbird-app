import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:in_app_review/in_app_review.dart';
import '../../models/env.dart';

// 리뷰 가능한 상태를 나타내는 enum
enum ReviewAvailability { loading, available, unavailable }

// 리뷰 서비스 관리 Provider
final reviewProvider =
    StateNotifierProvider<ReviewNotifier, ReviewAvailability>((ref) {
  return ReviewNotifier();
});

class ReviewNotifier extends StateNotifier<ReviewAvailability> {
  ReviewNotifier() : super(ReviewAvailability.loading) {
    _checkReviewAvailability();
  }

  final InAppReview _inAppReview = InAppReview.instance;
  final String _appStoreId = Env.appStoreApiKey; // iOS App Store ID

  Future<void> _checkReviewAvailability() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      state = isAvailable
          ? ReviewAvailability.available
          : ReviewAvailability.unavailable;
    } catch (_) {
      state = ReviewAvailability.unavailable;
    }
  }

  Future<void> requestReview(BuildContext context) async {
    if (state == ReviewAvailability.available) {
      try {
        await _inAppReview.requestReview();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리뷰 요청 실패: $e')),
        );
      }
    } else {
      openStoreListing(context);
    }
  }

  Future<void> openStoreListing(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        await _inAppReview.openStoreListing();
      } else if (Platform.isIOS) {
        await _inAppReview.openStoreListing(appStoreId: _appStoreId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이 플랫폼에서는 지원되지 않습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스토어 열기 실패: $e')),
      );
    }
  }
}


//final reviewService = ref.read(reviewProvider.notifier);
// ElevatedButton(
//           onPressed: () => reviewService.requestReview(context),
//           child: const Text('리뷰 요청'),
//         ),