import 'package:youtube_music/data/data_module/song_module.dart';




//  todo after finish the project remove the user
class Playlist {
  final int id;
  final String? playlistName;
  final List<Song>? songs;
  final bool? isPublic;
  final String? description;
  final DateTime? createdAt;
  final int? user;
  final String? playlistcoverimage;

  Playlist({required this.id,
    required this.playlistName,
     this.songs,
     this.isPublic,
     this.description,
     this.createdAt,
     this.user,
    this.playlistcoverimage
    });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(id: json['id']??0,
        songs: (json['songs'] as List ?)?.map((song)=>Song.fromJson(song)).toList(),
        isPublic: json['is_public'] ?? false,
        description: json['description']?.toString(),
        createdAt: json['created_at'] !=null ?DateTime.parse(json['created_at']):null,
        user: json['user'] ?? 0,
        playlistName: json['playlist_name']?.toString(),
      playlistcoverimage: json['playlist_cover_image']?.toString(),
    );
  }

  // @override
  // // TODO: implement image
  // String? get image => playlistcoverimage;
  //
  // @override
  // // TODO: implement song_id
  // int get song_id => songs!.map((son)=>son.id);
  //
  // @override
  // // TODO: implement song_title
  // String? get song_title => throw UnimplementedError();
  //
  // @override
  // // TODO: implement subtitle
  // String? get subtitle => throw UnimplementedError();
}

//
// class Playlist {
//   final int id;
//   final String? playlistName;
//   final List<Song>? songs;
//   final bool? isPublic;
//   final String? description;
//   final DateTime? createdAt;
//   final int? user;
//   final String? playlistcoverimage;
//
//   Playlist({
//     required this.id,
//     required this.playlistName,
//     this.songs,
//     this.isPublic,
//     this.description,
//     this.createdAt,
//     this.user,
//     this.playlistcoverimage
//   });
//
//   factory Playlist.fromJson(Map<String, dynamic> json) {
//     return Playlist(
//       id: json['id'] ?? 0,
//
//       playlistName: json['playlist_name']?.toString(),
//
//       songs: json['songs'] != null
//           ? (json['songs'] as List)
//           .map((song) => Song.fromJson(song))
//           .toList()
//           : [],
//
//       isPublic: json['is_public'] ?? false,
//
//       description: json['description']?.toString(),
//
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//
//       user: json['user'],
//       playlistcoverimage: json['playlist_cover_image']?.toString()
//     );
//   }
//
