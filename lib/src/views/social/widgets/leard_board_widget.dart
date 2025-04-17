import 'package:StudyDuck/core/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/admob_widget.dart';
import '../../../viewmodels/leader_board/leader_board_view_model_view_model.dart';

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
                  (leaderboardStatedata.length ~/ 3), // 3개 항목마다 광고 추가
              itemBuilder: (context, index) {
                // 광고 위치 계산 (3개 항목마다)
                if (index > 0 && index % 4 == 3) {
                  return AdMobWidget.showBannerAd(50, true);
                }

                // 실제 데이터 인덱스 계산 (광고 위치 고려)
                final dataIndex = index - (index ~/ 4);
                final player = leaderboardStatedata["rank_${dataIndex + 1}"];

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
                    gradient: dataIndex == 0
                        ? const LinearGradient(
                            colors: [Colors.amber, Colors.orange])
                        : dataIndex == 1
                            ? LinearGradient(
                                colors: [Colors.grey[200]!, Colors.grey[400]!])
                            : dataIndex == 2
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
                    title: Text(
                      (player["nickname"]?.isNotEmpty == true
                              ? player["nickname"]
                              : player["userId"]) ??
                          "Unknown",
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    //TODO : 한글화 작업 필요
                    subtitle: Text(
                        "공부시간 : ${getFormatTime(player["totalElapsedTime"])}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (dataIndex == 0)
                          const Icon(Icons.emoji_events,
                              color: Colors.yellow, size: 28),
                        if (dataIndex == 1)
                          const Icon(Icons.emoji_events,
                              color: Colors.grey, size: 28),
                        if (dataIndex == 2)
                          const Icon(Icons.emoji_events,
                              color: Colors.brown, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          "Rank ${dataIndex + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
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
