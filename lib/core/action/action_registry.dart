import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/action/action_item.dart';

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

  final main_page = Get.find<Main_Home_Page_Controller>();

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
      isVisible: (ctx) => ctx.entityType == EntityType.playlist || ctx.entityType ==EntityType.album,
      onExecute: (ctx) async {
        final controller = Get.find<get_current_song>();
        final song = ctx.entity;
        if (ctx.page == PageContext.queue) {
          controller.autoplayNextDataType(song, ctx.songIndex ?? -1);
        } else {
          controller.autoplayNextDataType(song, -1);
        }
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
        controller.AddToQueue(ctx.entity);
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
      id: ActionId.deletePlaylist,
      title: "Delete playlist",
      icon: CupertinoIcons.delete_simple,
      isVisible: (ctx) => ctx.entityType == EntityType.playlist,
      onExecute: (ctx) async {},
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
      isVisible: (ctx) => ctx.entityType== EntityType.song && ctx.page == PageContext.playlist,
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
      id: ActionId.goToAlbum,
      title: "Go to Album",
      icon: Icons.album,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song && ctx.page != PageContext.album,
      onExecute: (ctx) async {
        final main_page = Get.find<Main_Home_Page_Controller>();
        final Album_Controller album = Get.find<Album_Controller>();
        final song = ctx.entity;
        Get.back();
        final naviId = NavHelper.getNavId(main_page.current_index.value);
        await album.retrive_album_song_con(song.album!.id);
        Get.toNamed(App_route.album_page, id: naviId);
      },
    ),
    ActionItem(
      id: ActionId.goToArtist,
      title: "Go to Artist",
      icon: Icons.person_outline,
      isVisible: (ctx) =>
          ctx.page != PageContext.artist && (ctx.entityType ==EntityType.song || ctx.entityType == EntityType.album),
      onExecute: (ctx) async {
        final main_page = Get.find<Main_Home_Page_Controller>();
        final Artist_Controller artist = Get.find<Artist_Controller>();
        final song = ctx.entity;
        Get.back();
        final naviId = NavHelper.getNavId(main_page.current_index.value);
        await artist.retrive_artist_with_song(song.artist!.first.id);
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
      isVisible: (ctx) => ctx.entityType==EntityType.playlist && ctx.page == PageContext.playlist,
      onExecute: (ctx) async {},
    ),
  ];

  static List<ActionItem> com = [
    ActionItem(
      id: ActionId.playNext,
      title: "Play Next",
      icon: Icons.playlist_play,
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song &&
          ctx.entityType != EntityType.playlist,
      onExecute: (ctx) async {
        final controller = Get.find<get_current_song>();
        final song = ctx.entity;
        if (ctx.page == PageContext.queue) {
          controller.autoplayNextDataType(song, ctx.songIndex ?? -1);
        } else if (ctx.page == PageContext.playlist) {
          Get.back();
          controller.autoplayNextDataType(song, 0);
        } else {
          controller.autoplayNextDataType(song, -1);
        }
        // if(ctx.page == PageContext.playlist){
        //   Get.back();
        //   controller.autoplayNextDataType(song,0);
        // }
        Get.back();
      },
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
      isVisible: (ctx) =>
          ctx.entityType == EntityType.song ||
          ctx.entityType == EntityType.artist,
      onExecute: (ctx) async {},
    ),
  ];
}
