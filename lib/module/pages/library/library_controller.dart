import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Library_Controller extends GetxController {
  final current_library_index = 0.obs;
  final current_page_title = 'Library'.obs;

  @override
  void onInit() {
    get_current_lib_index();
    super.onInit();
  }

  Future<void> get_current_lib_index() async {
    final SharedPreferences pref =  await SharedPreferences.getInstance() ;
    current_library_index.value = pref.getInt('current_library_index') ?? 0;
    current_page_title.value = pref.getString('current_page_title')?? 'Library';
    print('the current page and title : ${current_page_title.value} , ${current_library_index.value}');
  }

  void change_current_index(int currentId,String title) async {
    current_library_index.value = currentId;
    current_page_title.value = title;

    final SharedPreferences pref =  await SharedPreferences.getInstance();
    await pref.setInt('current_library_index', current_library_index.value);
    await pref.setString('current_page_title', current_page_title.value);
  }
}
//
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Library_Controller extends GetxController {
//   final current_library_index = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadIndexOnce();
//   }
//
//   Future<void> _loadIndexOnce() async {
//     final pref = await SharedPreferences.getInstance();
//     final savedIndex = pref.getInt('current_library_index');
//
//     if (savedIndex != null) {
//       current_library_index.value = savedIndex;
//     }
//   }
//
//   Future<void> change_current_index(int index) async {
//     current_library_index.value = index;
//
//     final pref = await SharedPreferences.getInstance();
//     await pref.setInt('current_library_index', index);
//   }
// }
