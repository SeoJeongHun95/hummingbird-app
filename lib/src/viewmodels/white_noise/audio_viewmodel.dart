import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/whitenoise/audio_service.dart';
import '../../models/whitenoise/audio_model.dart';

class MultiAudioprovider extends StateNotifier<List<AudioModel>> {
  final MultiAudioService audioService;

  MultiAudioprovider({
    required this.audioService,
    required List<AudioModel> initialSounds,
  }) : super(initialSounds);

  void togglePlayback(String assetPath) async {
    state = state.map((audio) {
      if (audio.assetPath == assetPath) {
        PlaybackState newState = audio.playbackState == PlaybackState.playing
            ? PlaybackState.stopped
            : PlaybackState.playing;
        if (newState == PlaybackState.playing) {
          audioService.play(assetPath);
        } else {
          audioService.stop(assetPath);
        }
        return audio.copyWith(playbackState: newState);
      }
      return audio;
    }).toList();
  }

  void setVolume(String assetPath, double volume) async {
    await audioService.setVolume(assetPath, volume);

    state = state.map((audio) {
      if (audio.assetPath == assetPath) {
        return audio.copyWith(volume: volume);
      }
      return audio;
    }).toList();
  }

  Stream<Duration>? getPositionStream(String assetPath) {
    return audioService.positionStream(assetPath)?.map((position) {
      final index = state.indexWhere((audio) => audio.assetPath == assetPath);
      if (index != -1) {
        state = List.from(state);
        state[index] =
            state[index].copyWith(playbackState: state[index].playbackState);
      }
      return position;
    });
  }

  void stopAll() {
    audioService.stopAll();
    // 모든 오디오의 재생 상태를 'stopped'로 업데이트
    state = state.map((audio) {
      return audio.copyWith(playbackState: PlaybackState.stopped);
    }).toList();
  }

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }
}
