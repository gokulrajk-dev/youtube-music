import 'package:get/get.dart';
import 'package:flutter/material.dart';


class newPlaylistCreate extends StatelessWidget {
  const newPlaylistCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("New playlist",style: TextStyle(color: Colors.white),),
          TextField(
            decoration: InputDecoration(
              hintText: 'Title',
              hintStyle: TextStyle(color: Colors.grey),

            ),
          )
        ],
      ),
    );
  }
}
