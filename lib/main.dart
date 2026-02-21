import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/auth_service.dart';

import 'app/binding/init_binding.dart';
import 'firebase_options.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  await Auth_service.hasTokenValid();
  runApp(demo());
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
