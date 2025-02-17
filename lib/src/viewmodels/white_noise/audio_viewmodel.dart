import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/whitenoise/audio_model.dart';
import '../../../core/services/whitenoise/audio_service.dart';

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

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }
}
