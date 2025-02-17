import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../src/models/whitenoise/audio_model.dart';
import '../../../src/viewmodels/white_noise/audio_viewmodel.dart';

class MultiAudioService {
  final Map<String, AudioPlayer> _audioPlayers = {};

  Future<void> play(String assetPath) async {
    if (!_audioPlayers.containsKey(assetPath)) {
      final player = AudioPlayer();
      await player.setAsset(assetPath);
      await player.setLoopMode(LoopMode.all);
      await player.setVolume(0.3); // 볼륨을 30%로 설정
      _audioPlayers[assetPath] = player;
    }

    await _audioPlayers[assetPath]!.play();
  }

  Future<void> stop(String assetPath) async {
    await _audioPlayers[assetPath]?.stop();
    await _audioPlayers[assetPath]?.seek(Duration.zero);
  }

  Future<void> setVolume(String assetPath, double volume) async {
    await _audioPlayers[assetPath]?.setVolume(volume);
  }

  Stream<Duration>? positionStream(String assetPath) {
    return _audioPlayers[assetPath]?.positionStream;
  }

  void dispose() {
    _audioPlayers.forEach((_, player) => player.dispose());
    _audioPlayers.clear();
  }
}

final multiAudioViewModelProvider =
    StateNotifierProvider<MultiAudioprovider, List<AudioModel>>((ref) {
  return MultiAudioprovider(
    audioService: MultiAudioService(),
    initialSounds: [
      AudioModel(
          name: 'Cafe',
          assetPath: 'lib/core/mp3/cafe-noise-32940.mp3',
          imagePath: 'lib/core/imgs/whitenoise/cafe.png'),
      AudioModel(
          name: 'Rain',
          assetPath: 'lib/core/mp3/sound-of-falling-rain-145473.mp3',
          imagePath: 'lib/core/imgs/whitenoise/rain.png'),
      AudioModel(
          name: 'Wind',
          assetPath: 'lib/core/mp3/wind__artic__cold-6195.mp3',
          imagePath: 'lib/core/imgs/whitenoise/wind.png'),
      AudioModel(
          name: 'Fire',
          assetPath: 'lib/core/mp3/fireplace-with-crackling-sounds.mp3',
          imagePath: 'lib/core/imgs/whitenoise/fireplase.png'),
      AudioModel(
          name: 'Chime',
          assetPath: 'lib/core/mp3/wind-chime-small-64660.mp3',
          imagePath: 'lib/core/imgs/whitenoise/windchime.png'),
      AudioModel(
          name: 'Stream',
          assetPath:
              'lib/core/mp3/the-sound-of-a-stream-a-spring-stream-the-sound-of-water-109237.mp3',
          imagePath: 'lib/core/imgs/whitenoise/stream.png'),
      AudioModel(
          name: 'Wave',
          assetPath: 'lib/core/mp3/soft-waves-on-the-beach-sound-190884.mp3',
          imagePath: 'lib/core/imgs/whitenoise/wave.png'),
      AudioModel(
          name: 'Bird',
          assetPath:
              'lib/core/mp3/evening-birds-singing-in-spring-background-sounds-of-nature-146388.mp3',
          imagePath: 'lib/core/imgs/whitenoise/bird.png'),
    ],
  );
});
