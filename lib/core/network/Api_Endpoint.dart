
class Api_Endpoint {
  static const new_login='/user_accounts/auth/google/';
  static const refresh_token ='/user_accounts/auth/token/refresh/';
  static const get_current_user = "/user_accounts/get_staff/";
  static const get_song ='/songs_app/Song_views/';
  static const get_current_id_song = '/songs_app/Song_demo_edit_views/';
  static String get_modity_current_song_id(int CurrentSongId){
    return '${get_current_id_song}$CurrentSongId/';
  }
  static const get_like_song='/songs_app/like_views/';
  static const post_del_user_like_song = '/songs_app/like_and_unlike_views/';
}