import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/services/whitenoise/audio_service.dart';
import '../../../core/widgets/admob_widget.dart';
import '../../models/whitenoise/audio_model.dart';

class WhiteNoiseScreen extends ConsumerWidget {
  const WhiteNoiseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioList = ref.watch(multiAudioViewModelProvider);
    final screenWidth = ScreenUtil().screenWidth;
    // final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 재생 중인 항목을 앞쪽으로 정렬
    final sortedAudioList = [...audioList]..sort((a, b) {
        if (a.playbackState == PlaybackState.playing &&
            b.playbackState != PlaybackState.playing) {
          return -1;
        } else if (a.playbackState != PlaybackState.playing &&
            b.playbackState == PlaybackState.playing) {
          return 1;
        }
        return 0;
      });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'WhiteNoiseScreen.WhiteNoise',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ).tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 470.h,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (screenWidth ~/ 150).toInt(),
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: sortedAudioList.length,
                  itemBuilder: (context, index) {
                    final audio = sortedAudioList[index];
                    return _buildSoundControlButton(context, ref, audio);
                  },
                ),
              ),
              Gap(16),
              Expanded(
                child: AdMobWidget.showBannerAd(100.h),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoundControlButton(
      BuildContext context, WidgetRef ref, AudioModel audio) {
    return Stack(
      children: [
        // 배경 이미지
        Container(
          width: 200.w,
          height: 200.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              audio.imagePath,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),

        // Card 내용
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          color: Colors.black38,
          child: InkWell(
            onTap: () => ref
                .read(multiAudioViewModelProvider.notifier)
                .togglePlayback(audio.assetPath),
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getPlaybackIcon(audio.playbackState),
                    size: 40.r,
                    color: Colors.white,
                  ),
                  // const Gap(8),
                  SizedBox(
                    width: 60.w,
                    child: Text(
                      tr(audio.name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                    child: StreamBuilder<Duration>(
                      stream: ref
                          .read(multiAudioViewModelProvider.notifier)
                          .getPositionStream(audio.assetPath),
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return Text(
                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            _buildVolumeDialog(context, ref, audio),
                      );
                    },
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getPlaybackIcon(PlaybackState state) {
    switch (state) {
      case PlaybackState.stopped:
        return Icons.play_arrow;
      case PlaybackState.playing:
        return Icons.stop;
    }
  }

  Widget _buildVolumeDialog(
      BuildContext context, WidgetRef ref, AudioModel audio) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 280.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
            const Text(
              "WhiteNoiseScreen.Volume Control",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            const Gap(20),
            Consumer(
              builder: (context, ref, child) {
                final currentVolume = ref.watch(
                    multiAudioViewModelProvider.select((audioList) => audioList
                        .firstWhere(
                            (element) => element.assetPath == audio.assetPath)
                        .volume));
                return Slider(
                  value: currentVolume,
                  onChanged: (value) => ref
                      .read(multiAudioViewModelProvider.notifier)
                      .setVolume(audio.assetPath, value),
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: currentVolume.toStringAsFixed(1),
                );
              },
            ),
            const Gap(16),
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
              child: const Text(
                "WhiteNoiseScreen.Close",
                style: TextStyle(fontSize: 16),
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
