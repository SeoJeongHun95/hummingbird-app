import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BreathingPhase { intro, instruction, countdown, completed }

class BreathingExerciseWidget extends StatefulWidget {
  const BreathingExerciseWidget({super.key});

  @override
  State<BreathingExerciseWidget> createState() =>
      _BreathingExerciseWidgetState();
}

class _BreathingExerciseWidgetState extends State<BreathingExerciseWidget> {
  BreathingPhase _currentPhase = BreathingPhase.intro;
  int _currentStepIndex = 0;
  int _countdown = 0;
  int _repetitionCount = 0;
  Timer? _timer;
  String _currentInstruction = '';

  final List<Map<String, dynamic>> _steps = [
    {
      'instruction': tr("BreathingExercise.Inhale"),
      'duration': 4
    }, // 입을 다물고 코로 4초 동안 천천히 숨을 들이마십니다.
    {
      'instruction': tr("BreathingExercise.Hold"),
      'duration': 7
    }, // 숨을 7초 동안 참습니다.
    {
      'instruction': tr("BreathingExercise.Exhale"),
      'duration': 8
    }, // 입을 약간 벌리고 8초 동안 천천히 완전히 숨을 내쉬면서 "쉬-" 하는 소리를 냅니다.
  ];

  final int _totalRepetitions = 3;
  final Duration _introDuration = const Duration(seconds: 2);
  final Duration _instructionPreviewDuration = const Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    _startIntroPhase();
  }

  void _startIntroPhase() {
    if (!mounted) return;
    setState(() {
      _currentPhase = BreathingPhase.intro;
      _currentInstruction = tr("BreathingExercise.Intro");
    });
    Future.delayed(_introDuration, () {
      if (mounted) {
        _startInstructionPhase();
      }
    });
  }

  void _startInstructionPhase() {
    if (!mounted || _currentPhase == BreathingPhase.completed) return;
    setState(() {
      _currentPhase = BreathingPhase.instruction;
      _currentInstruction = _steps[_currentStepIndex]['instruction'];
    });
    Future.delayed(_instructionPreviewDuration, () {
      if (mounted && _currentPhase == BreathingPhase.instruction) {
        // Check phase again
        _startCountdownPhase();
      }
    });
  }

  void _startCountdownPhase() {
    if (!mounted || _currentPhase == BreathingPhase.completed) return;
    setState(() {
      _currentPhase = BreathingPhase.countdown;
      _countdown = _steps[_currentStepIndex]['duration'];
    });

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          timer.cancel();
          // Move to the next step or repetition
          _currentStepIndex++;
          if (_currentStepIndex >= _steps.length) {
            _currentStepIndex = 0;
            _repetitionCount++;
            if (_repetitionCount >= _totalRepetitions) {
              _currentPhase = BreathingPhase.completed;
              _currentInstruction = tr("BreathingExercise.Completed");
            }
          }
          if (_currentPhase != BreathingPhase.completed) {
            _startInstructionPhase(); // Start next instruction preview
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_currentPhase) {
      case BreathingPhase.intro:
      case BreathingPhase.instruction:
      case BreathingPhase.completed:
        content = Text(
          _currentInstruction,
          style: TextStyle(
              fontWeight: _currentPhase == BreathingPhase.completed
                  ? FontWeight.bold
                  : FontWeight.w500,
              fontSize: _currentPhase == BreathingPhase.intro
                  ? 14.sp
                  : 16.sp), // Smaller font for intro
          textAlign: TextAlign.center,
        );
        break;
      case BreathingPhase.countdown:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _steps[_currentStepIndex]['instruction'],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              '$_countdown',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.sp,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        );
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          // Use AnimatedSwitcher for smooth transitions
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Container(
            // Add key for AnimatedSwitcher
            key: ValueKey<BreathingPhase>(_currentPhase),
            child: content,
          ),
        ),
        if (_currentPhase != BreathingPhase.intro &&
            _currentPhase != BreathingPhase.completed)
          SizedBox(height: 5.h),
        if (_currentPhase != BreathingPhase.intro &&
            _currentPhase != BreathingPhase.completed)
          Text(
            '${tr("BreathingExercise.Repetition")} ${_repetitionCount + 1} / $_totalRepetitions',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
