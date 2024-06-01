import 'package:blog_app_with_firebase/components/roundbutton.dart';
import 'package:blog_app_with_firebase/user_interface/login_screen.dart';
import 'package:blog_app_with_firebase/user_interface/signup_screen.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Blog App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Image(
                  image: NetworkImage(
                      'https://t3.ftcdn.net/jpg/04/28/95/04/360_F_428950438_huH4H4ljvjUNHmihS5c1Zz8KvlGpGISo.jpg'))),
          SizedBox(
            height: 20,
          ),
          RoundButton(
              title: 'Log in',
              ontap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()))),
          SizedBox(
            height: 20,
          ),
          RoundButton(
              title: 'Sign Up',
              ontap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupScreen())))
        ],
      ),
    );
  }
}
