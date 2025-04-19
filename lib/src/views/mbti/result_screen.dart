import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Correct import
import '../../../core/utils/screen_share.dart';
import '../../../core/widgets/admob_widget.dart';

class ResultScreen extends StatefulWidget {
  final String mbtiType;
  final Function(String)? onMbtiResult;
  final bool isResoultScreen;
  const ResultScreen({
    super.key,
    required this.mbtiType,
    this.onMbtiResult,
    required this.isResoultScreen,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final DeviceInfoPlugin deviceInfo =
      DeviceInfoPlugin(); // Properly defined here
  final screenShare = ScreenShare();
  bool isSharing = false;
  final GlobalKey _printKey = GlobalKey();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // MBTI 결과를 부모 위젯에 전달
    if (widget.onMbtiResult != null) {
      widget.onMbtiResult!(widget.mbtiType);
    }
  }

  final Map<String, Map<String, String>> learningTips = {};

  Future<void> handleShare() async {
    if (isSharing) return;

    setState(() {
      isSharing = true;
    });

    bool permissionGranted = false;

    try {
      // 플랫폼별 권한 확인 (Android 버전에 따라 다른 권한 요청)
      if (Platform.isAndroid) {
        // Android 버전 확인 using deviceInfo
        final androidInfo = await deviceInfo.androidInfo; // Correct usage
        final sdkInt = androidInfo.version.sdkInt;

        print('Android SDK Version: $sdkInt');

        if (sdkInt >= 33) {
          // Android 13 이상
          final status = await Permission.photos.status;
          print('Android 13+ Photos permission status: $status');

          if (!status.isGranted) {
            final result = await Permission.photos.request();
            print('Android 13+ Photos permission request result: $result');
            permissionGranted = result.isGranted;
          } else {
            permissionGranted = true;
          }
        } else {
          // Android 12 이하
          final status = await Permission.storage.status;
          print('Android Storage permission status: $status');

          if (!status.isGranted) {
            final result = await Permission.storage.request();
            print('Android Storage permission request result: $result');
            permissionGranted = result.isGranted;
          } else {
            permissionGranted = true;
          }
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.status;
        print('iOS Photos permission status: $status');

        if (!status.isGranted) {
          final result = await Permission.photos.request();
          print('iOS Photos permission request result: $result');
          permissionGranted = result.isGranted;
        } else {
          permissionGranted = true;
        }
      }

      if (!permissionGranted) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('mbtiResult.permissionTitle').tr(),
            content: const Text('mbtiResult.permissionDenied').tr(),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('mbtiResult.confirm').tr(),
              ),
              TextButton(
                onPressed: () => openAppSettings(),
                child: const Text('mbtiResult.openSettings').tr(),
              ),
            ],
          ),
        );
        return;
      }

      final tips = learningTips[widget.mbtiType] ??
          {"안내": "해당 MBTI 유형의 학습 팁이 준비되지 않았습니다."};

      // Rest of your handleShare logic...
      final content = RepaintBoundary(
        key: _printKey,
        child: Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'mbtiResult.analysisTitle',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ).tr(),
                ),
                const SizedBox(height: 32),
                _buildMbtiHeader(widget.mbtiType),
                const Divider(height: 40),
                _buildQuickInfoSection(tips),
                const Divider(height: 40),
                _buildDetailedTipsSection(tips),
                const Divider(height: 40),
                _buildConsultingSummary(tips),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("www.studyduck.net",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      Column(
                        children: [
                          Text(
                            "mbtiResult.ProvidedbyStudyDuckApp",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "mbtiResult.AnalysisDate",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ).tr(),
                              Text(
                                ': ${DateTime.now().toString().substring(0, 10)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      print('Attempting to capture and share content');
      await screenShare.captureAndShare(content);
      print('Content captured and shared successfully');

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('mbtiResult.shareComplete').tr(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('mbtiResult.confirm').tr(),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error during sharing: $e');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(tr('mbtiResult.shareFailed') + ': $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('mbtiResult.confirm').tr(),
            ),
          ],
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tips = learningTips[widget.mbtiType] ?? {};
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        // actions: [
        //   IconButton(
        //     onPressed: isSharing ? null : handleShare,
        //     icon: Icon(isSharing ? Icons.hourglass_empty : Icons.share),
        //   ),
        // ],
        elevation: 0, //
        // backgroundColor: Colors.white,
      ),
      body: screenShare.wrapWithScreenshot(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMbtiHeader(widget.mbtiType),
              _buildQuickInfoSection(tips),
              AdMobWidget.showBannerAd(50),
              _buildDetailedTipsSection(tips),
              AdMobWidget.showBannerAd(50),
              _buildConsultingSummary(tips),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.isResoultScreen == false
                      ? _MoveToThePageAfterTheMBTItest()
                      : Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  "mbtiResult.confirm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
              ),
              AdMobWidget.showBannerAd(50),
            ],
          ),
        ),
      ),
    );
  }

  void _MoveToThePageAfterTheMBTItest() async {
    print("MBTI 결과 화면에서 온 경우");
    if (widget.onMbtiResult != null) {
      await widget.onMbtiResult!(widget.mbtiType);
    }
    if (!mounted) return;
    int count = 0;
    Navigator.of(context).popUntil((route) {
      return count++ == 2;
    });
  }

  Widget _buildMbtiHeader(String type) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'lib/core/imgs/mbti/$type.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'mbtiResult.analysisResult',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ).tr(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoSection(Map<String, String> tips) {
    final mbtiType = widget.mbtiType;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'mbtiResult.quickInfo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            const SizedBox(height: 16),
            _buildInfoRow(
              tr('mbtiResult.recommendedTime'),
              tr('mbtiTypeResult.$mbtiType.recommendedTime'),
            ),
            _buildInfoRow(
              tr('mbtiResult.dailyStudyTime'),
              tr('mbtiTypeResult.$mbtiType.dailyStudyTime'),
            ),
            _buildInfoRow(
              tr('mbtiResult.strongSubjects'),
              tr('mbtiTypeResult.$mbtiType.strongSubjects'),
            ),
            _buildInfoRow(
              tr('mbtiResult.weakSubjects'),
              tr('mbtiTypeResult.$mbtiType.weakSubjects'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedTipsSection(Map<String, String> tips) {
    final mbtiType = widget.mbtiType;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'mbtiResult.learningGuide',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            const SizedBox(height: 16),
            _buildInfoRow(
              tr('mbtiResult.learningMethod'),
              tr('mbtiTypeResult.$mbtiType.learningMethod'),
            ),
            _buildInfoRow(
              tr('mbtiResult.timeManagement'),
              tr('mbtiTypeResult.$mbtiType.timeManagement'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultingSummary(Map<String, String> tips) {
    final mbtiType = widget.mbtiType;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'mbtiResult.consultingSummary',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Text(
                tr('mbtiTypeResult.$mbtiType.consultingSummary'),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              tr(value),
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ).tr(),
          ),
        ],
      ),
    );
  }
}
