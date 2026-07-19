import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/action/action_item.dart';
import 'package:youtube_music/data/data_module/album_module.dart';
import 'package:youtube_music/data/data_module/artist.dart';
import 'package:youtube_music/data/data_module/like_model.dart';
import 'package:youtube_music/data/data_module/playlist.dart';
import 'package:youtube_music/data/data_module/song_module.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';

import '../../module/pages/Album/album_controller.dart';
import '../../module/pages/Artist/artist_controller.dart';
import '../../module/pages/globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../../module/pages/home/controllers/all_song_controller.dart';
import '../../module/pages/like_page/like_controller.dart';
import '../../module/pages/main_home_page/main_home_page_controller.dart';
import '../../module/pages/playlist_page/playlist_controller.dart';
import '../../route/app_route.dart';
import '../../services/helper_code/helper_code.dart';
import 'action_context.dart';
import 'action_id.dart';

class ActionRegistry {
  final get_current_song controller = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();

  static List<ActionItem> all = [
    ActionItem(
      id: ActionId.shufflePlay,
      title: "Shuffle play",
      icon: CupertinoIcons.shuffle,
      isVisible: (ctx) =>
          ctx.entityType != EntityType.artist &&
          ctx.entityType != EntityType.song,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.startMix,
      title: "Start mix",
      icon: CupertinoIcons.dot_radiowaves_left_right,
      isVisible: (ctx) =>
          ctx.entityType != EntityType.artist &&
          ctx.entityType != EntityType.song,
      onExecute: (ctx) async {},
    ),
    //  todo after finish the project i have time we add edit playlist outside playlist
    ActionItem(
      id: ActionId.playNext,
      title: "Play Next",
      icon: Icons.playlist_play,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.playlist ||
          ctx.page == PageContext.album || ctx.entityType == EntityType.like,
      onExecute: (ctx) async {

        final controller = Get.find<get_current_song>();

        final songs = extractSongs(ctx.entity);

        controller.autoplayNextDataType(songs, 0);

        Get.back();
      },
    ),
    ActionItem(
      id: ActionId.addToQueue,
      title: "Add to Queue",
      icon: Icons.queue_music,
      isVisible: (ctx) => ctx.entityType != EntityType.artist,
      onExecute: (ctx) async {

        final controller = Get.find<get_current_song>();

        final songs = extractSongs(ctx.entity);

        controller.AddToQueue(songs);

        Get.back();
      },
    ),
    ActionItem(
      id: ActionId.saveToPlaylist,
      title: "Save to playlist",
      icon: Icons.playlist_add,
      isVisible: (ctx) =>
          ctx.entityType != EntityType.artist &&
          ctx.entityType != EntityType.song,
      onExecute: (ctx) async {

        final songs = extractSongs(ctx.entity);

        Get.back();

        Get.bottomSheet(
          DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return showPlaylistBottomSheet(
                controller: scrollController,
                songId: songs.map((e) => e.id).toList(),
              );
            },
          ),
          isScrollControlled: true,
        );
      },
    ),
    ActionItem(
      id: ActionId.deletePlaylist,
      title: "Delete playlist",
      icon: CupertinoIcons.delete_simple,
      isVisible: (ctx) => ctx.entityType == EntityType.playlist,
      onExecute: (ctx) async {
        Get.back();
        showDialog(
          context: Get.context!,
          builder: (context) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delete this Playlist?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                child: const Center(
                                  child: Text(
                                    '\tCancel\t',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                  final playlistSong =
                                      Get.find<Playlist_Controller>();
                                  final playlists = ctx.entity;
                                  Get.back();
                                  await playlistSong.deleteExistPlaylist(
                                    playlists.id,
                                    ctx.songIndex ?? -1,
                                  );
                                  Get.back(); // close dialog
                                  if (ctx.page == PageContext.playlist) {
                                    Get.back(); // leave playlist page
                                  }
                                },
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.white)),
                                child: const Text(
                                  '\tDelete\t',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
    ActionItem(
      id: ActionId.saveToLibrary,
      title: "Save to Library",
      icon: Icons.library_add,
      isVisible: (ctx) => !ctx.isSaved && ctx.entityType != EntityType.artist,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.removeFromLibrary,
      title: "Remove from Library",
      icon: Icons.delete_outline,
      isVisible: (ctx) => ctx.isSaved,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.dismissQueue,
      title: "Dismiss queue",
      icon: Icons.remove_road,
      isVisible: (ctx) => ctx.page == PageContext.queue,
      onExecute: (ctx) async {
        final controller = Get.find<get_current_song>();
        controller.dismissQueue(ctx.songIndex ?? -1);
        Get.back();
      },
    ),
    ActionItem(
      id: ActionId.removeFromPlaylist,
      title: "Remove from Playlist",
      icon: Icons.delete,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song && ctx.page == PageContext.playlist,
      onExecute: (ctx) async {
        final playlist = Get.find<Playlist_Controller>();
        final song = ctx.entity;
        Get.back();
        await playlist.removeSongFromPlaylist(
            playlist.user_playlist_song.value!.id,
            [song.id],
            "delete",
            ctx.songIndex ?? -1);
      },
    ),
    ActionItem(
      id: ActionId.download,
      title: "Download",
      icon: CupertinoIcons.arrow_down_to_line_alt,
      isVisible: (ctx) => ctx.entityType == EntityType.song,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.removeLike,
      title: "Remove from like",
      icon: CupertinoIcons.delete,
      isVisible: (ctx) => ctx.page == PageContext.like,
      onExecute: (ctx) async {
        final Like_Controller like = Get.find<Like_Controller>();
        final song = ctx.entity as Song;
        await like.post_del_user_like(song);
        Get.back();
      },
    ),
    ActionItem(
      id: ActionId.goToAlbum,
      title: "Go to Album",
      icon: Icons.album,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song && ctx.page != PageContext.album,
      onExecute: (ctx) async {
        final mainPage = Get.find<Main_Home_Page_Controller>();
        final Album_Controller album = Get.find<Album_Controller>();
        final song = ctx.entity;
        Get.back();
        final naviId = NavHelper.getNavId(mainPage.current_index.value);
        await album.retrive_album_song_con(song.album!.id);
        Get.toNamed(App_route.album_page, id: naviId);
      },
    ),
    ActionItem(
      id: ActionId.goToArtist,
      title: "Go to Artist",
      icon: Icons.person_outline,
      isVisible: (ctx) =>
          ctx.page != PageContext.artist &&
          (ctx.entityType == EntityType.song ||
              ctx.entityType == EntityType.album),
      onExecute: (ctx) async {
        final mainPage = Get.find<Main_Home_Page_Controller>();
        final Artist_Controller artist = Get.find<Artist_Controller>();
        final song =
            ctx.entity is Album ? ctx.entity.artists : ctx.entity.artist;
        Get.back();
        final naviId = NavHelper.getNavId(mainPage.current_index.value);
        await artist.retrive_artist_with_song(song.first.id);
        Get.toNamed(App_route.artist_page, id: naviId);
      },
    ),

    ActionItem(
      id: ActionId.viewCredits,
      title: "View song credits",
      icon: CupertinoIcons.person_3,
      isVisible: (ctx) => ctx.entityType == EntityType.song,
      onExecute: (ctx) async {},
    ),

    ActionItem(
      id: ActionId.removeHistory,
      title: "Remove from History",
      icon: CupertinoIcons.delete_simple,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song && ctx.page == PageContext.history,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.pin,
      title: "Pin to speed dial",
      icon: CupertinoIcons.pin,
      isVisible: (ctx) => ctx.entityType == EntityType.song,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.notInterest,
      title: "Not interested",
      icon: Icons.not_interested,
      isVisible: (ctx) => ctx.entityType == EntityType.song,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.helpAndFeedback,
      title: "Help and feedback",
      icon: Icons.help_outline,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.playlist &&
          ctx.page == PageContext.playlist,
      onExecute: (ctx) async {},
    ),
  ];

  static List<ActionItem> com = [
    ActionItem(
      id: ActionId.playNext,
      title: "Play Next",
      icon: Icons.playlist_play,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song ||
          (ctx.entityType == EntityType.album &&
              ctx.entityType != EntityType.playlist),
      onExecute: (ctx) async {
        final controller = Get.find<get_current_song>();
        final song =
            ctx.entity is Album ? ctx.entity.songAlbum ?? [] : ctx.entity;
        Get.back();
        if (ctx.page == PageContext.queue) {
          //todo use the issongfilter to switch queue and recomemntation song
          controller.autoplayNextDataType(song, ctx.songIndex ?? -1,true);
        } else if (ctx.entityType == EntityType.album) {
          controller.autoplayNextDataType(song, 0,);
        } else {
          controller.autoplayNextDataType(song, -1);
        }
      },
    ),
    ActionItem(
      id: ActionId.saveToLibrary,
      title: "Saved",
      icon: CupertinoIcons.bookmark,
      isVisible: (ctx) => ctx.entityType == EntityType.album,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.saveToPlaylist,
      title: "Save to playlist",
      icon: Icons.playlist_add,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song &&
          ctx.entityType != EntityType.playlist,
      onExecute: (ctx) async {
        final song = ctx.entity;
        Get.back();
        Get.bottomSheet(
          DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return showPlaylistBottomSheet(
                controller: scrollController,
                songId: [song.id],
              );
            },
          ),
          isScrollControlled: true,
        );
      },
    ),
    ActionItem(
      id: ActionId.shufflePlay,
      title: "Shuffle play",
      icon: CupertinoIcons.shuffle,
      isVisible: (ctx) => ctx.entityType == EntityType.artist,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.startMix,
      title: "Start mix",
      icon: CupertinoIcons.dot_radiowaves_left_right,
      isVisible: (ctx) => ctx.entityType == EntityType.artist,
      onExecute: (ctx) async {},
    ),
    ActionItem(
      id: ActionId.share,
      title: "Share",
      icon: CupertinoIcons.arrow_turn_up_right,
      isVisible: (ctx) => ctx.entityType != EntityType.playlist,
      onExecute: (ctx) async {},
    ),
  ];
  static List<Song> extractSongs(dynamic entity) {

    if (entity is Album) {
      return entity.songAlbum ?? <Song>[];
    }

    if (entity is Playlist) {
      return entity.songs ?? <Song>[];
    }

    if (entity is RxList<LikeModel>) {
      return entity
          .map<Song>((item) => item.song!)
          .toList();
    }

    if (entity is List<LikeModel>) {
      return entity
          .map<Song>((item) => item.song!)
          .toList();
    }

    if (entity is Song) {
      return [entity];
    }

    return <Song>[];
  }
}

class BottomSheetHeaderMapper {
  static BottomSheetHeader map(ActionContext ctx) {
    switch (ctx.entityType) {
      case EntityType.song:
        final songs = ctx.entity as Song;
        return BottomSheetHeader(
            title: songs.title ?? "",
            coverImage: songs.coverImage ?? "",
            subtitle: songs.artist!.map((e) => e.artistName).join(","));
      case EntityType.album:
        final albums = ctx.entity as Album;
        return BottomSheetHeader(
            title: albums.title ?? "",
            coverImage: albums.coverImage ?? "",
            subtitle: albums.artists!.map((e) => e.artistName).join(","));
      case EntityType.playlist:
        final playlists = ctx.entity as Playlist;
        return BottomSheetHeader(
          title: playlists.playlistName ?? "",
          coverImage: playlists.playlistcoverimage ?? "",
        );
      case EntityType.artist:
        final artists = ctx.entity as Artist;
        return BottomSheetHeader(
          title: artists.artistName ?? "",
          coverImage: artists.artistImage ?? "",
        );
      case EntityType.like:
        final user = Get.find<user_details_controller>();
        final like = ctx.entity as RxList<LikeModel>;
        return BottomSheetHeader(title: "Liked music", coverImage: "",subtitle: "${user.user.value!.userName} . ${like.length}");
      default:
        return BottomSheetHeader(title: "", coverImage: "");
    }
  }
}
