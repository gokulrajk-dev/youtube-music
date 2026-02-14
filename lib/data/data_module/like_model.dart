import 'package:youtube_music/data/data_module/song_module.dart';

class LikeModel {
    final int id;
    final Song? song;
    final DateTime? likeAt;
    final int? user;

    LikeModel({
        required this.id,
         this.song,
         this.likeAt,
         this.user,
    });

    factory LikeModel.fromJson(Map<String, dynamic> json) {
        return LikeModel(
            id: json['id'] ?? 0,
            song: json['song'] != null?Song.fromJson(json['song'])  :null,
            likeAt: json['like_at']!= null?DateTime.parse(json['like_at']):null,
            user: json['user'],
        );
    }
}
