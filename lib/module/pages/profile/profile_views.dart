import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';
import 'package:youtube_music/module/pages/login/auth_controller_google_login.dart';
import 'package:youtube_music/route/app_route.dart';

class Feature {
  final IconData icon;
  final dynamic text;
  Feature({required this.icon, required this.text,  this.g,this.onTap});
  final dynamic g;
  final dynamic onTap;

}

class Profile_Views extends StatefulWidget {
  const Profile_Views({super.key});

  @override
  State<Profile_Views> createState() => _Profile_ViewsState();
}

class _Profile_ViewsState extends State<Profile_Views> {
  final auth_google_login k = Get.find();
  final user_details_controller con =
  Get.find<user_details_controller>();

  List<Feature> feature = [
    Feature(icon: CupertinoIcons.profile_circled,
        text: 'Your Channel',
        g: App_route.home_pages),
    Feature(icon: Icons.save, text: 'Downloads', g: App_route.home_pages),
    Feature(icon: Icons.history, text: 'History', g: App_route.history_page),
    Feature(icon: CupertinoIcons.backward_fill,
        text: 'Your Recap',
        g: App_route.home_pages),
    Feature(icon: CupertinoIcons.envelope_badge_fill,
        text: 'Badges',
        g: App_route.home_pages),
    Feature(icon: Icons.switch_account_outlined, text: 'Switch Account', g: ''),
    Feature(icon: Icons.settings, text: 'Settings', g: App_route.home_pages),
    Feature(icon: Icons.help_outline,
        text: 'Help and Feedback',
        g: App_route.home_pages),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 40,
              )),
          title: Text(
            'Account',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        k.Switch_google_Account();
                      },
                      child: Obx(
                              () {
                                if(con.is_loading.value){
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if(con.error.value.isNotEmpty){
                                  return Center(
                                    child: Text('${con.error.value}'),
                                  );
                                }
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                NetworkImage(con.user.value!.photoUrl),
                              ),
                              titleAlignment: ListTileTitleAlignment.center,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${con.user.value!.userName}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${con.user.value!.gmail}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              trailing: Icon(CupertinoIcons.right_chevron),
                            );
                          }),
                    );
                  }
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: ListView.builder(
              itemCount: feature.length,
              itemBuilder: (context, index) {
                final wid = feature[index];
                return GestureDetector(
                  onTap: () {
                    if (wid.text == 'Switch Account') {
                      k.Switch_google_Account();
                      return;
                    }

                    Get.toNamed(wid.g,id: 4);
                    Get.back();
                  },
                  child: ListTile(
                    leading: Icon(wid.icon),
                    title: Text(wid.text),
                  ),
                );
              }),
        )
    );
  }
}


// class Profile_Views extends GetView<Profile_Controller> {
//   final auth_google_login k = Get.put<auth_google_login>(auth_google_login());
//   final user_details_controller con =
//       Get.put<user_details_controller>(user_details_controller());
//
// List<Feature> feature =[
//   Feature(icon: CupertinoIcons.profile_circled, text: 'Your Channel',g: App_route.home_pages),
//   Feature(icon: Icons.save, text: 'Downloads',g: App_route.home_pages),
//   Feature(icon: Icons.history, text: 'History',g: App_route.home_pages),
//   Feature(icon: CupertinoIcons.backward_fill, text: 'Your Recap',g: App_route.home_pages),
//   Feature(icon:CupertinoIcons.envelope_badge_fill, text: 'Badges',g: App_route.home_pages),
//   Feature(icon: Icons.switch_account_outlined, text: 'Switch Account',g: ''),
//   Feature(icon: Icons.settings, text: 'Settings',g: App_route.home_pages),
//   Feature(icon: Icons.help_outline, text: 'Help and Feedback',g: App_route.home_pages),
// ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Get.back();
//
//               },
//               icon: Icon(
//                 Icons.close,
//                 color: Colors.black,
//                 size: 40,
//               )),
//           title: Text(
//             'Account',
//             style: TextStyle(
//                 color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
//           ),
//           bottom: PreferredSize(
//               preferredSize: Size.fromHeight(70),
//               child: Builder(
//                 builder: (context) {
//                   return GestureDetector(
//                     onTap: (){
//                       k.SignInWithGoogle();
//                     },
//                     child: Obx(
//                       () => ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: NetworkImage(con.user.value!.photoUrl),
//                         ),
//                         titleAlignment: ListTileTitleAlignment.center,
//                         title: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               '${con.user.value!.userName}',
//                               style: TextStyle(
//                                   color: Colors.black, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               '${con.user.value!.gmail}',
//                               style: TextStyle(
//                                   color: Colors.black, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         trailing: Icon(CupertinoIcons.right_chevron),
//                       ),
//                     ),
//                   );
//                 }
//               )),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.only(top: 28.0),
//           child: ListView.builder(
//             itemCount: feature.length,
//               itemBuilder: (context,index){
//             final  wid = feature[index];
//             return GestureDetector(
//               onTap: (){
//                 if(wid.text=='Switch Account'){
//                   k.SignInWithGoogle();
//                   return;
//                 }
//                 Get.toNamed(wid.g);
//               },
//               child: ListTile(
//                 leading: Icon(wid.icon),
//                 title:Text(wid.text),
//               ),
//             );
//           }),
//         )
//     );
//   }
// }
