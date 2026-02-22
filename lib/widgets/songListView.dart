import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/data/data_module/song_module.dart';

import '../module/pages/globle_bottom_sheet/globle_bottom_sheet_views.dart';

class SongListViews extends StatelessWidget {
  final List<Song> songs;
  final void Function(Song song) onTap;

  const SongListViews({
    super.key,
    required this.songs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Center(
        child: Text(
          'No songs available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: songs.map((playlist_songs) {
        return ListTile(
          onTap: () => onTap(playlist_songs), // ✅ FIXED
          style: ListTileStyle.drawer,
          leading: playlist_songs.coverImage != null
              ? Image.network(playlist_songs.coverImage!)
              : const Icon(Icons.music_note, color: Colors.white),

          title: Text(
            playlist_songs.title ?? "Unknown",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),

          subtitle: Text(
            playlist_songs.artist
                ?.map((artist) => artist.artistName)
                .join(', ') ??
                "",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          trailing: IconButton(
            onPressed: () {
              Get.bottomSheet(
                DraggableScrollableSheet(
                  expand: false,
                  builder: (context, scrollController) {
                    return globle_bottom_sheet(
                      controllers: scrollController,
                      song_cover_img: playlist_songs.coverImage,
                      song_title: playlist_songs.title,
                      song_artist: playlist_songs.artist,
                      song_id: playlist_songs.id,
                      album_id: playlist_songs.album!.id,
                      artist_id: playlist_songs.artist!.first.id,
                    );
                  },
                ),
                isScrollControlled: true,
              );
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}
