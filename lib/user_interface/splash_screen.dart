import 'dart:async';

import 'package:blog_app_with_firebase/user_interface/home_screen.dart';
import 'package:blog_app_with_firebase/user_interface/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // this code is to check weather user is already log in or not
    // TODO: implement initState

    final user = auth.currentUser;

    if (user != null) {
      Timer(
          Duration(seconds: 6),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    } else {
      Duration(seconds: 4);
      () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => OptionScreen()));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
              image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpA27B7vgpKx2qfdN8UOHy1MMAYw87h8m1JA&usqp=CAU'))
        ],
      ),
    );
  }
}
