import 'package:flutter/material.dart';

import '../../../../core/router/bottom_nav_bar.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  bool showFriendsOnly = false;

  final List<Map<String, dynamic>> leaderboard = [
    {"name": "Rozkyczi", "score": 4396, "avatar": "👑"},
    {"name": "joshtheboss6912", "score": 730, "avatar": "🎩"},
    {"name": "ValiantCleric5709", "score": 221, "avatar": "🧙‍♂️"},
    {"name": "AuspiciousCard89366", "score": 181, "avatar": "🐨"},
    {"name": "HypnoticBlade78605", "score": 141, "avatar": "🧢"},
    {"name": "Makart2", "score": 118, "avatar": "🧁"},
  ];

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String secs = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("All Time",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Text("All",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Switch(
                      value: showFriendsOnly,
                      activeColor: Colors.deepPurple,
                      onChanged: (value) =>
                          setState(() => showFriendsOnly = value),
                    ),
                    const Text("Friends",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final player = leaderboard[index];
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
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(player["avatar"],
                          style: const TextStyle(fontSize: 24)),
                    ),
                    title: Text(player["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("공부시간: ${formatDuration(player["score"])}",
                        style: const TextStyle(color: Colors.black54)),
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
                        Text("Rank ${index + 1}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
