import 'package:StudyDuck/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodels/leader_board/leader_board_view_model_view_model.dart';

class LeardBoardWidget extends ConsumerWidget {
  const LeardBoardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue leaderboardState = ref.watch(leaderBoardViewModelProvider);

    return Container(
      child: leaderboardState.when(
        data: (leaderboardStatedata) {
          return Expanded(
            child: ListView.builder(
              itemCount: leaderboardStatedata.length,
              itemBuilder: (context, index) {
                final player = leaderboardStatedata["rank_${index + 1}"];

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
                    gradient: index == 0
                        ? const LinearGradient(
                            colors: [Colors.amber, Colors.orange])
                        : index == 1
                            ? LinearGradient(
                                colors: [Colors.grey[200]!, Colors.grey[400]!])
                            : index == 2
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
                    subtitle: Text(
                        "공부시간 : ${getFormatTime(player["totalElapsedTime"])}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index == 0)
                          const Icon(Icons.emoji_events,
                              color: Colors.yellow, size: 28),
                        if (index == 1)
                          const Icon(Icons.emoji_events,
                              color: Colors.grey, size: 28),
                        if (index == 2)
                          const Icon(Icons.emoji_events,
                              color: Colors.brown, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          "Rank ${index + 1}",
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
