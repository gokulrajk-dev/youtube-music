import 'package:flutter/material.dart';
import 'package:youtube_music/core/action/action_item.dart';

import 'action_context.dart';
import 'action_id.dart';

class ActionRegistry{
  static List<ActionItem> all=[
    ActionItem(
      id: ActionId.playNext,
      title: "Play Next",
      icon: Icons.playlist_play,
      isVisible: (ctx) => ctx.entityType == EntityType.song,
      onExecute: (ctx) async {},
    ),

    ActionItem(
      id: ActionId.addToQueue,
      title: "Add to Queue",
      icon: Icons.queue_music,
      isVisible: (ctx) => ctx.entityType == EntityType.song,
      onExecute: (ctx) async {},
    ),

    ActionItem(
      id: ActionId.removeFromPlaylist,
      title: "Remove from Playlist",
      icon: Icons.delete,
      isVisible: (ctx) =>
      ctx.page == PageContext.playlist && ctx.isOwner,
      onExecute: (ctx) async {},
    ),

    ActionItem(
      id: ActionId.goToAlbum,
      title: "Go to Album",
      icon: Icons.album,
      isVisible: (ctx) =>
      ctx.entityType == EntityType.song &&
          ctx.page != PageContext.album,
      onExecute: (ctx) async {},
    ),

    ActionItem(
      id: ActionId.goToArtist,
      title: "Go to Artist",
      icon: Icons.person,
      isVisible: (ctx) =>
      ctx.entityType == EntityType.song &&
          ctx.page != PageContext.artist,
      onExecute: (ctx) async {},
    ),

    ActionItem(
      id: ActionId.saveToLibrary,
      title: "Save to Library",
      icon: Icons.library_add,
      isVisible: (ctx) => !ctx.isSaved,
      onExecute: (ctx) async {},
    ),

    ActionItem(
      id: ActionId.removeFromLibrary,
      title: "Remove from Library",
      icon: Icons.delete_outline,
      isVisible: (ctx) => ctx.isSaved,
      onExecute: (ctx) async {},
    ),
  ];
}