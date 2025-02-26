class AudioModel {
  final String name;
  final String assetPath;
  final String imagePath;
  final PlaybackState playbackState;
  final double volume;

  AudioModel({
    required this.name,
    required this.assetPath,
    required this.imagePath,
    this.playbackState = PlaybackState.stopped,
    this.volume = 0.3,
  });

  AudioModel copyWith({
    String? name,
    String? assetPath,
    String? imagePath,
    PlaybackState? playbackState,
    double? volume,
  }) {
    return AudioModel(
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      imagePath: imagePath ?? this.imagePath,
      playbackState: playbackState ?? this.playbackState,
      volume: volume ?? this.volume,
    );
  }

  // Static method inside the AudioModel class
  static AudioModel empty() {
    return AudioModel(
      name: '',
      assetPath: '',
      imagePath: '',
      playbackState: PlaybackState.stopped,
      volume: 0.0,
    );
  }
}

enum PlaybackState {
  playing,
  stopped,
}
