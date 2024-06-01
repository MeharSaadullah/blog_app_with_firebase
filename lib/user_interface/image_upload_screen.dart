//1 st add image picker in yamal 2nd add permissions in ANDRIODManifest.xml which is located in andriod,app,scr,main
// if we want to store images in database we have to add 2 dependencies in yaml firebase storage and firebase database
import 'dart:io';

//import 'package:another_flushbar/flushbar.dart';
//import 'package:another_flushbar/flushbar.dart';
//import 'package:blog_app_with_firebase/Utils/utils.dart';
import 'package:blog_app_with_firebase/Utils/utils.dart';
import 'package:blog_app_with_firebase/components/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final titlecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  bool loading = false;
  // this code is for giving option to pick image from gallery or camera we call this function at center of this code
  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getGalleryImage();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.browse_gallery),
                      title: Text('Gallery'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  final postRef = FirebaseDatabase.instance.ref().child('Posts');

  // code to pick image from gallery
  File? _image;
  // code for storage of images
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage
      .instance; // this code is for intilizing storage for upload of image.
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage Storage =
      firebase_storage.FirebaseStorage.instance;
  // DatabaseReference databaseRef = FirebaseDatabase.instance
  //     .ref('Post'); // initlize that table in which we want to store image

  Future getGalleryImage() async {
    final PickedFile = await picker.pickImage(
      source: ImageSource.gallery, //code to pick image from gallery
    );
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('No image Picked');
      }
    });
  }

  Future getCameraImage() async {
    final PickedFile = await picker.pickImage(
      source: ImageSource.camera, //code to pick image from camera
    );
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('No image Picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Center(child: Text('Image Uploader')),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  dialog(context); // here we call that function
                },
                child: Center(
                  child: InkWell(
                    onTap: () {
                      dialog(context);
                    },
                    child: Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: _image != null
                          ? Image.file(_image!.absolute)
                          : // this code is for show image on front end
                          Icon(Icons.image),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: titlecontroller,
                // obscureText: true, // for password hide
                decoration: InputDecoration(
                    hintText: 'Title',
                    helperText: 'Enter Title of Blog',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                    labelText: 'Title'),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Title';
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: descriptioncontroller,
                // obscureText: true, // for password hide
                decoration: InputDecoration(
                    hintText: 'Description',
                    helperText: 'Enter Description for Blog',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    labelText: 'Description'),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Description';
                  }
                },
              ),
              SizedBox(height: 10),
              RoundButton(
                  title: 'Upload Image',
                  ontap: () async {
                    setState(() {
                      loading = true;
                    });

                    try {
                      int date = DateTime.now().microsecondsSinceEpoch;
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref('/blog app with firebase$date');
                      firebase_storage.UploadTask uploadTask =
                          ref.putFile(_image!.absolute);
                      await Future.value(uploadTask);
                      var newUrl = await ref.getDownloadURL();
                      final User? user = _auth.currentUser;
                      postRef
                          .child('Post List')
                          .child(date.toString())
                          .set({
                            'pId': date.toString(),
                            'pImage': newUrl.toString(),
                            'pTime': date.toString(),
                            'pTitle': titlecontroller.text.toString(),
                            'pDescription':
                                descriptioncontroller.text.toString(),
                            'uEmail': user!.email.toString(),
                          })
                          .then((value) => {
                                Utils.flushBarErrorMessage(
                                    'Post Uploaded', context),
                                setState(() {
                                  loading = false;
                                })
                              })
                          .onError((error, stackTrace) => {
                                Utils.flushBarErrorMessage(
                                    error.toString(), context),
                                setState(() {
                                  loading = false;
                                })
                              });
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils.flushBarErrorMessage(e.toString(), context);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
