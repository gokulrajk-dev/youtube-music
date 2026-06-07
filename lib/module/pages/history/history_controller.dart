import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/data_module/user_history.dart';
import 'package:youtube_music/data/user_respository/user_history_respository.dart';

class Histroy_Controller extends base_controller{
  final RxList<UserHistory> history = <UserHistory>[].obs;
  final UserHistoryCrud historyCrud = UserHistoryCrud();
  final ScrollController scrollController=ScrollController();
  final hasValue = true.obs;
  int currentPageNumber = 1;

  @override
  void onInit() {
    get_current_song_history();
    scrollController.addListener((){
      if(scrollController.position.pixels >=scrollController.position.maxScrollExtent-200){
        if(!is_loading.value && hasValue.value){
          get_current_song_history();
        }
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> get_current_song_history() async{
    if(!hasValue.value) return;
    try{
      get_isloading(true);
      noerror();
      final response = await historyCrud.get_user_song_history(currentPageNumber);
      
      final List result = response['results'];
      
      final List<UserHistory> newHistroy=result.map((e)=>UserHistory.fromJson(e)).toList();

      history.addAll(newHistroy);

      if(response['next']==null){
        hasValue.value=false;
      }
      else{
        currentPageNumber++;
      }
    }catch(e){
      get_error(e.toString());
    }finally{
      get_isloading(false);
    }
  }
}
