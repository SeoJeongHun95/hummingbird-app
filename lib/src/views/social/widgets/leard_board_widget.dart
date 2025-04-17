import 'package:StudyDuck/core/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodels/leader_board/leader_board_view_model_view_model.dart';
import '../../../../core/widgets/admob_widget.dart';

class LeaderboardWidget extends ConsumerWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue leaderboardState = ref.watch(leaderBoardViewModelProvider);

    return Container(
      child: leaderboardState.when(
        data: (leaderboardStatedata) {
          if (leaderboardStatedata.isEmpty) {
            return Center(
              child: Text(
                tr("Rank.NotReady"),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
              itemCount: leaderboardStatedata.length +
                  (leaderboardStatedata.length / 3).floor(),
              itemBuilder: (context, index) {
                // 3개 항목마다 광고 표시
                if (index > 0 && index % 4 == 3) {
                  return AdMobWidget.showBannerAd(50, true);
                }

                // 실제 인덱스 계산 (광고 공간을 고려)
                final actualIndex = index - (index ~/ 4);
                final player = leaderboardStatedata["rank_${actualIndex + 1}"];

                if (player == null) {
                  return SizedBox.shrink();
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: actualIndex == 0
                        ? const LinearGradient(
                            colors: [Colors.amber, Colors.orange])
                        : actualIndex == 1
                            ? LinearGradient(
                                colors: [Colors.grey[200]!, Colors.grey[400]!])
                            : actualIndex == 2
                                ? LinearGradient(colors: [
                                    Colors.brown[100]!,
                                    Colors.brown[300]!
                                  ])
                                : const LinearGradient(
                                    colors: [Colors.white, Colors.white]),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (actualIndex == 0)
                          const Icon(Icons.emoji_events,
                              color: Colors.yellow, size: 28),
                        if (actualIndex == 1)
                          const Icon(Icons.emoji_events,
                              color: Colors.grey, size: 28),
                        if (actualIndex == 2)
                          const Icon(Icons.emoji_events,
                              color: Colors.brown, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          "Rank ${actualIndex + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    title: Text(
                      (player["nickname"]?.isNotEmpty == true
                              ? player["nickname"]
                              : player["userId"]) ??
                          "Unknown",
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                    subtitle: Text(
                      "공부시간 : ${getFormatTime(player["totalElapsedTime"])}",
                      textAlign: TextAlign.end,
                    ),
                    trailing: null,
                  ),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
