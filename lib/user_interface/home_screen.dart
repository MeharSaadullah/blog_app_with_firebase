//import 'dart:ffi';

import 'package:blog_app_with_firebase/user_interface/image_upload_screen.dart';
//import 'package:blog_app_with_firebase/user_interface/login_screen.dart';
import 'package:blog_app_with_firebase/user_interface/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('Posts');
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            title: Center(child: Text('Blog Reading')),
            actions: [
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageUploadScreen())),
                child: Icon(Icons.add),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  auth.signOut().then(
                        (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OptionScreen())),
                      );
                },
                child: Icon(Icons.logout),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                Expanded(
                    child: FirebaseAnimatedList(
                  query: dbRef.child('Post List'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                                placeholder: 'loading',
                                image:
                                    snapshot.child('pImage').value.toString()),
                          ),

                          // image: snapshot.value!['pImage']),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            snapshot.child('pTitle').value.toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(snapshot.child('pDescription').value.toString()),
                        ],
                      ),
                    );
                  },
                ))
              ],
            ),
          )),
    );
  }
}
