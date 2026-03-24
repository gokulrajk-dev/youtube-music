import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/auth_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  await Auth_service.hasTokenValid();
  runApp(const demo());
}

class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: App_route.splash,
      getPages: App_route.route,
    );
  }
}

//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: HomePage(),
//   ));
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> animation;
//
//   double minHeight = 70;
//   double maxHeight = 0;
//   double currentHeight = 70;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//   }
//
//   void animateTo(double target) {
//     animation = Tween(
//       begin: currentHeight,
//       end: target,
//     ).animate(CurvedAnimation(
//       parent: controller,
//       curve: Curves.easeInOut,
//     ))
//       ..addListener(() {
//         setState(() {
//           currentHeight = animation.value;
//         });
//       });
//
//     controller.forward(from: 0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           maxHeight = constraints.maxHeight;
//           return Stack(
//             children: [
//               // 🔹 Background UI
//               Center(
//                 child: Text(
//                   "HOME SCREEN",
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//               ),
//
//               // 🔥 PLAYER
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: GestureDetector(
//                   onVerticalDragUpdate: (details) {
//                     setState(() {
//                       currentHeight -= details.delta.dy;
//                       currentHeight =
//                           currentHeight.clamp(minHeight, maxHeight);
//                     });
//                   },
//
//                   onVerticalDragEnd: (details) {
//                     final velocity = details.primaryVelocity ?? 0;
//
//                     if (velocity < -500) {
//                       animateTo(maxHeight); // expand
//                     } else if (velocity > 500) {
//                       animateTo(minHeight); // shrink
//                     } else {
//                       if (currentHeight > maxHeight / 2) {
//                         animateTo(maxHeight);
//                       } else {
//                         animateTo(minHeight);
//                       }
//                     }
//                   },
//
//                   onTap: () {
//                     if (currentHeight == minHeight) {
//                       animateTo(maxHeight);
//                     } else {
//                       animateTo(minHeight);
//                     }
//                   },
//
//                   child: Container(
//                     height: currentHeight,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: currentHeight == minHeight
//                           ? BorderRadius.zero
//                           : BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child: currentHeight <= minHeight + 10
//                         ? MiniPlayer()
//                         : FullPlayer(),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
//
// class MiniPlayer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage:
//             NetworkImage("https://picsum.photos/200"),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               "bye bye bye",
//               style: TextStyle(color: Colors.white),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Icon(Icons.play_arrow, color: Colors.white),
//         ],
//       ),
//     );
//   }
// }
//
//
// class FullPlayer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Column(
//         children: [
//           SizedBox(height: 40),
//
//           // drag handle
//           Container(
//             height: 5,
//             width: 40,
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//
//           SizedBox(height: 20),
//
//           // album image
//           Container(
//             height: 250,
//             width: 250,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: NetworkImage("https://picsum.photos/400"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//
//           SizedBox(height: 20),
//
//           Text(
//             "bye bye bye",
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold),
//           ),
//
//           Text(
//             "Mahaprabu, gokulraj",
//             style: TextStyle(color: Colors.grey),
//           ),
//
//           SizedBox(height: 20),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.skip_previous, color: Colors.white, size: 40),
//               SizedBox(width: 20),
//               Icon(Icons.play_arrow, color: Colors.white, size: 60),
//               SizedBox(width: 20),
//               Icon(Icons.skip_next, color: Colors.white, size: 40),
//             ],
//           ),
//
//           SizedBox(height: 20),
//
//           TabBar(
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               Tab(text: "UP NEXT"),
//               Tab(text: "LYRICS"),
//               Tab(text: "RELATED"),
//             ],
//           ),
//
//           Expanded(
//             child: TabBarView(
//               children: [
//                 Center(
//                     child: Text("Up Next",
//                         style: TextStyle(color: Colors.white))),
//                 Center(
//                     child: Text("Lyrics",
//                         style: TextStyle(color: Colors.white))),
//                 Center(
//                     child: Text("Related",
//                         style: TextStyle(color: Colors.white))),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }