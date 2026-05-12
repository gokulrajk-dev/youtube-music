enum EntityType { song, album, playlist, artist }

enum PageContext { home, album, artist, playlist, queue,like,history,library}

class ActionContext {
  final EntityType entityType;
  final dynamic entity;
  final PageContext page;
  final dynamic songIndex;

  final bool isOwner;
  final bool isSaved;
  final bool isDownloaded;

  ActionContext(
      {required this.entityType,
      required this.entity,
      required this.page,
      this.isOwner = false,
      this.isSaved = false,
      this.isDownloaded = false,
        this.songIndex
      });

}
