import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../src/models/whitenoise/audio_model.dart';
import '../../../src/viewmodels/white_noise/audio_viewmodel.dart';

class MultiAudioService {
  final Map<String, FlutterSoundPlayer> _audioPlayers = {};

  // Asset 파일을 임시 파일로 복사하는 헬퍼 함수
  Future<String> _getAudioFilePath(String assetPath) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${assetPath.split('/').last}');

    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
    }

    return file.path;
  }

  Future<void> play(String assetPath) async {
    if (!_audioPlayers.containsKey(assetPath)) {
      final player = FlutterSoundPlayer();
      await player.openPlayer(); // openAudioSession() 대신 openPlayer() 사용

      // Asset 파일을 임시 파일로 복사
      final audioFilePath = await _getAudioFilePath(assetPath);

      // 초기 볼륨 설정 (0.5 = 50%)
      await player.setVolume(0.5);

      await player.startPlayer(
        fromURI: audioFilePath,
        codec: Codec.mp3,
        whenFinished: () async {
          // 재생이 끝나면 다시 시작
          await play(assetPath);
        },
      );

      _audioPlayers[assetPath] = player;
    } else {
      final player = _audioPlayers[assetPath]!;
      if (!player.isPlaying) {
        final audioFilePath = await _getAudioFilePath(assetPath);
        await player.startPlayer(
          fromURI: audioFilePath,
          codec: Codec.mp3,
          whenFinished: () async {
            await play(assetPath);
          },
        );
      }
    }
  }

  Future<void> stop(String assetPath) async {
    final player = _audioPlayers[assetPath];
    if (player != null && player.isPlaying) {
      await player.stopPlayer();
    }
  }

  Future<void> setVolume(String assetPath, double volume) async {
    final player = _audioPlayers[assetPath];
    if (player != null) {
      // 볼륨값을 0.0 ~ 1.0 사이로 제한
      double normalizedVolume = volume.clamp(0.0, 1.0);
      try {
        await player.setVolume(normalizedVolume);
        print('Volume set to: $normalizedVolume for $assetPath'); // 디버깅용
      } catch (e) {
        print('Error setting volume: $e'); // 디버깅용
        // 에러 발생시 재시도
        await Future.delayed(Duration(milliseconds: 100));
        await player.setVolume(normalizedVolume);
      }
    }
  }

  Stream<Duration>? positionStream(String assetPath) {
    final player = _audioPlayers[assetPath];
    return player?.onProgress?.map((e) => e.duration);
  }

  void dispose() {
    for (var player in _audioPlayers.values) {
      player.stopPlayer();
      player.closePlayer();
    }
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
