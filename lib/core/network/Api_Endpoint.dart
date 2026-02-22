
class Api_Endpoint {
  static const new_login='/user_accounts/auth/google/';
  static const refresh_token ='/user_accounts/auth/token/refresh/';
  static const get_current_user = "/user_accounts/get_staff/";
  static const get_song ='/songs_app/Song_views/';
  static const get_current_id_song = '/songs_app/Song_demo_edit_views/';
  static const get_like_song='/songs_app/like_views/';
  static const post_del_user_like_song = '/songs_app/like_and_unlike_views/';
  static const  get_current_user_playlist ='/songs_app/playlist_views/';
  static const get_user_pic_playlist ='/songs_app/playlist_edit_views/';
  static const get_album_song ='/songs_app/album_views/';
  static const get_current_user_history = '/songs_app/listen_history_views/';
  static const get_artist ='/songs_app/artist_views/';
  static String get_modity_current_song_id(int CurrentSongId){
    return '${get_current_id_song}$CurrentSongId/';
  }
  static String get_current_user_pic_playlist(int pickPlaylistId){
    return '${get_user_pic_playlist}$pickPlaylistId/';
  }

  static String get_user_pick_album_song(int AlbumId){
    return '${get_album_song}$AlbumId/';
  }
  static String get_artist_song(int ArtistId){
    return '${get_artist}$ArtistId/';
  }


}