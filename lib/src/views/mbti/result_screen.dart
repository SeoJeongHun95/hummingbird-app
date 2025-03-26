import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/screen_share.dart';
import 'mbti_screen.dart';

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
  final screenShare = ScreenShare();
  bool isSharing = false;
  final GlobalKey _printKey = GlobalKey();
  bool isLoading = false;

  final Map<String, Map<String, String>> learningTips = {};

  Future<void> handleShare() async {
    if (isSharing) return;

    setState(() {
      isSharing = true;
    });

    final tips = learningTips[widget.mbtiType] ??
        {"안내": "해당 MBTI 유형의 학습 팁이 준비되지 않았습니다."};

    try {
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

      await screenShare.captureAndShare(content);

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
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('mbtiResult.shareFailed'),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tips = learningTips[widget.mbtiType] ?? {};

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: isSharing ? null : handleShare,
            icon: Icon(isSharing ? Icons.hourglass_empty : Icons.share),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: screenShare.wrapWithScreenshot(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMbtiHeader(widget.mbtiType),
              const SizedBox(height: 20),
              _buildQuickInfoSection(tips),
              const SizedBox(height: 20),
              _buildDetailedTipsSection(tips),
              const SizedBox(height: 20),
              _buildConsultingSummary(tips),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    // 나의 MBTI 결과화면에서 온건지 체크
                    widget.isResoultScreen == false
                        ? _MoveToThePageAfterTheMBTItest()
                        : Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // 모서리를 각지게 설정
                    ),
                  ),
                  child: Text("mbtiResult.confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                      .tr()),
            ],
          ),
        ),
      ),
    );
  }

  void _MoveToThePageAfterTheMBTItest() {
    print("MBTI 결과 화면에서 온 경우");
    widget.onMbtiResult?.call(widget.mbtiType);
    // 이전 화면들을 모두 제거하고 결과값 전달
    int count = 0;
    Navigator.of(context).popUntil((route) {
      return count++ == 2;
    });
  }

  Widget _buildMbtiHeader(String type) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DecoratedBox(
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
                  'lib/core/imgs/mbti/$type.png', // 이미지 경로 수정
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
