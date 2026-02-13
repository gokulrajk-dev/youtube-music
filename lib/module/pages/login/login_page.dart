import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller_google_login.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final auth_google_login controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/_joker1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,top: 40,bottom: 10),
                    child: Container(
                      height: 100,
                      width: 200,
                      color: Colors.red,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        'No Ads Only Music',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Arial"),
                      ),
                      Text(
                        'Listen any song, any time without any ads!',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ]),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,top: 30,bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(onPressed: (){
                          controller.SignInWithGoogle();
                        }, child: Text('Sign in',style: TextStyle(color: Colors.black),)),
                        OutlinedButton(onPressed: (){
                          controller.signOut();
                        }, child: Text('device fiels only',style: TextStyle(color: Colors.white),)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // demo code for spacer()
            // Padding(
            //   padding: const EdgeInsets.all(24),
            //   child: Column(
            //     children: [
            //       // 🔴 Top logo section
            //       const SizedBox(height: 40),
            //       Container(
            //         height: 100,
            //         width: 200,
            //         color: Colors.red,
            //       ),
            //
            //       // 🧠 Push content to center
            //       const Spacer(),
            //
            //       // 📝 Text section
            //       Column(
            //         children: const [
            //           Text(
            //             'No Ads Only Music',
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 22,
            //             ),
            //             textAlign: TextAlign.center,
            //           ),
            //           SizedBox(height: 8),
            //           Text(
            //             'Listen any song, any time without any ads!',
            //             style: TextStyle(
            //               color: Colors.grey,
            //               fontSize: 15,
            //             ),
            //             textAlign: TextAlign.center,
            //           ),
            //         ],
            //       ),
            //
            //       // 🧠 Push buttons to bottom
            //       const Spacer(),
            //
            //       // 🔘 Buttons
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: [
            //           ElevatedButton(
            //             onPressed: () {},
            //             child: const Text('Sign in'),
            //           ),
            //           const SizedBox(height: 12),
            //           OutlinedButton(
            //             onPressed: () {},
            //             child: const Text('Create account'),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 20),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
