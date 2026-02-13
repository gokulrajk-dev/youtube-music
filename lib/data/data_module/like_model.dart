import 'package:youtube_music/data/data_module/song_module.dart';

class LikeModel {
    final int id;
    final Song song;
    final DateTime likeAt;
    final int user;

    LikeModel({
        required this.id,
        required this.song,
        required this.likeAt,
        required this.user,
    });

    factory LikeModel.fromJson(Map<String, dynamic> json) {
        return LikeModel(
            id: json['id'],
            song: Song.fromJson(json['song']),
            likeAt: DateTime.parse(json['like_at']),
            user: json['user'],
        );
    }
}
