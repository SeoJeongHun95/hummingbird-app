import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/background_play_controller.dart';

class WhiteNoiseScreen extends StatefulWidget {
  const WhiteNoiseScreen({super.key});

  @override
  State<WhiteNoiseScreen> createState() => _WhiteNoiseScreenState();
}

class _WhiteNoiseScreenState extends State<WhiteNoiseScreen> {
  final BackgroundPlayController controller = BackgroundPlayController();
  final Map<String, BackgroundPlayController> controllers = {
    'cafe': BackgroundPlayController(),
    'rain': BackgroundPlayController(),
    'wind': BackgroundPlayController(),
    'fire': BackgroundPlayController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          tr('WhiteNoiseScreen.whiteNoise'),
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  tr('WhiteNoiseScreen.chooseYourWhiteNoise'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      soundControlButton(tr('WhiteNoiseScreen.cafeNoise'),
                          'lib/core/mp3/cafe-noise-32940.mp3', 'cafe'),
                      soundControlButton(
                          tr('WhiteNoiseScreen.rainNoise'),
                          'lib/core/mp3/sound-of-falling-rain-145473.mp3',
                          'rain'),
                      soundControlButton(tr('WhiteNoiseScreen.windNoise'),
                          'lib/core/mp3/wind__artic__cold-6195.mp3', 'wind'),
                      soundControlButton(
                          tr('WhiteNoiseScreen.fireNoise'),
                          'lib/core/mp3/fireplace-with-crackling-sounds.mp3',
                          'fire'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget soundControlButton(
      String soundName, String soundFilePath, String key) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<PlaybackState>(
        valueListenable: controllers[key]!.playbackState,
        builder: (context, state, _) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  soundName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    StreamBuilder<Duration>(
                      stream: controllers[key]!.positionStream(),
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return Text(
                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 16),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        switch (state) {
                          case PlaybackState.stopped:
                            controllers[key]!
                                .playBackgroundLoopAudio(soundFilePath);
                            controllers[key]!.playbackState.value =
                                PlaybackState.playing;
                            break;
                          case PlaybackState.playing:
                            controllers[key]!.pauseBackgroundAudio();
                            controllers[key]!.playbackState.value =
                                PlaybackState.paused;
                            break;
                          case PlaybackState.paused:
                            controllers[key]!.resumeBackgroundAudio();
                            controllers[key]!.playbackState.value =
                                PlaybackState.playing;

                            break;
                        }
                      },
                      icon: state == PlaybackState.stopped
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.blue,
                                ),
                                setVolumeButton(key),
                              ],
                            )
                          : state == PlaybackState.playing
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.pause,
                                      color: Colors.red,
                                    ),
                                    setVolumeButton(key),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.red,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controllers[key]!.stopBackgroundAudio();
                                        setState(() {
                                          controllers[key]!
                                              .playbackState
                                              .value = PlaybackState.stopped;
                                        });
                                      },
                                      icon: state == PlaybackState.paused
                                          ? const Icon(
                                              Icons.stop,
                                              color: Colors.black54,
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget playbackDurationText() {
    return StreamBuilder<Duration>(
      stream: controller.positionStream(),
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return Text(
          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 14),
        );
      },
    );
  }

  Widget volumeController(String key) {
    return ValueListenableBuilder<double>(
      valueListenable: controllers[key]!.volumeNotifier,
      builder: (context, volume, _) {
        return Slider(
          value: volume,
          onChanged: (value) {
            controllers[key]!.setVolume(value);
          },
          min: 0,
          max: 1,
          divisions: 10,
          label: volume.toStringAsFixed(1),
        );
      },
    );
  }

  setVolumeButton(String key) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tr('WhiteNoiseScreen.volumeControl'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    volumeController(key),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        tr('WhiteNoiseScreen.close'),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.volume_up),
    );
  }
}
