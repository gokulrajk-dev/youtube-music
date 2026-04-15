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

    return ListView.builder(
      shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final playlist_songs = songs[index];
        return ListTile(
          onTap: () => onTap(playlist_songs),
          onLongPress: () {
            Get.bottomSheet(
              DraggableScrollableSheet(
                expand: false,
                builder: (context, scrollController) {
                  return globle_bottom_sheet(
                    controllers: scrollController,
                    song: playlist_songs,
                    type:"playlist"
                  );
                },
              ),
              isScrollControlled: true,
            );
          },
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
                      song: playlist_songs,
                      type: "playlist",
                      songIndex: index,
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
      });
  }
}
