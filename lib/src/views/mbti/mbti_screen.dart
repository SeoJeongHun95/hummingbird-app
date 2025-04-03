import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/services/mbti/mbti_question_service.dart';
import '../../../core/utils/selection_haptic.dart';
import '../../../core/widgets/admob_widget.dart';
import '../../models/mbti/mbti_question_model.dart';
import 'result_screen.dart';

class MBTIScreen extends StatefulWidget {
  final Function(String)? onMbtiResult;
  const MBTIScreen({super.key, this.onMbtiResult});

  @override
  State<MBTIScreen> createState() => _MBTIScreenState();
}

class _MBTIScreenState extends State<MBTIScreen> {
  int currentQuestionIndex = 0;
  List<MBTIQuestion> questions = [];
  bool isLoading = true;
  String currentLang = 'ko';

  Map<String, int> scores = {
    'E': 0,
    'I': 0,
    'S': 0,
    'N': 0,
    'T': 0,
    'F': 0,
    'J': 0,
    'P': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => isLoading = true);
    try {
      final loadedQuestions =
          await MBTIQuestionService.getQuestions(currentLang);
      if (!mounted) return;
      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        questions = [];
        isLoading = false;
      });
      // 에러 처리를 위한 다이얼로그 표시
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('mbtiResult.error').tr(),
            content: Text('mbtiResult.Failedtoloadthequestion').tr(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _loadQuestions(); // 다시 시도
                },
                child: const Text('mbtiResult.Tryagain').tr(),
              ),
            ],
          ),
        );
      }
    }
  }

  void _handleAnswer(bool isOptionA) async {
    // 햅틱 피드백 추가
    await SelectionHaptic.vibrate();

    final question = questions[currentQuestionIndex];

    String category = question.category;

    if (isOptionA) {
      scores[category.split('/')[0]] =
          (scores[category.split('/')[0]] ?? 0) + 1;
    } else {
      scores[category.split('/')[1]] =
          (scores[category.split('/')[1]] ?? 0) + 1;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    String mbtiResult = '';
    mbtiResult += scores['E']! > scores['I']! ? 'E' : 'I';
    mbtiResult += scores['S']! > scores['N']! ? 'S' : 'N';
    mbtiResult += scores['T']! > scores['F']! ? 'T' : 'F';
    mbtiResult += scores['J']! > scores['P']! ? 'J' : 'P';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          mbtiType: mbtiResult,
          onMbtiResult: widget.onMbtiResult,
          isResoultScreen: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || questions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('mbtiResult.MBTILearningStyleTest').tr(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'mbtiResult.question',
                  style: const TextStyle(fontSize: 16),
                ).tr(),
                Text(
                  ': ${currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr('mbti.MBTIQuestion${currentQuestionIndex + 1}.question'),
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => _handleAnswer(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // 모서리를 각지게 설정
                            ),
                          ),
                          child: Text(
                              tr(
                                  'mbti.MBTIQuestion${currentQuestionIndex + 1}.optionA'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => _handleAnswer(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // 모서리를 각지게 설정
                            ),
                          ),
                          child: Text(
                                  'mbti.MBTIQuestion${currentQuestionIndex + 1}.optionB',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                              .tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              //광고자리
              flex: 3,
              //광고자리
              child: Column(
                children: [
                  AdMobWidget.showExpandedBannerAd(100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
