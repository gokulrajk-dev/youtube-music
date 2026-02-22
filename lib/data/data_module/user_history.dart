import 'package:youtube_music/data/data_module/song_module.dart';

class UserHistory {
  final int id;
  final Song? song;
  final int? user;
  final String? playedAt;
  final String? days;
  final String? duration;
  final int? count;

  UserHistory(
      {required this.id,
      this.user,
      this.playedAt,
      this.days,
      this.duration,
      this.count,
      this.song});

  factory UserHistory.fromJson(Map<String, dynamic> json) {
    return UserHistory(
      id: json['id'] ?? 0,
      song: json['song'] != null ? Song.fromJson(json['song']) : null,
      duration: json['duration_played']!.toString(),
      count: json['count'] ?? 0,
      days: json['days']!.toString(),
      playedAt: json['played_at']!.toString(),
      user: json['user'] ?? 0,
    );
  }
}
