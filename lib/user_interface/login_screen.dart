import 'package:blog_app_with_firebase/Utils/utils.dart';
import 'package:blog_app_with_firebase/components/roundbutton.dart';
import 'package:blog_app_with_firebase/user_interface/Forgot_password_screen.dart';
import 'package:blog_app_with_firebase/user_interface/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showspinner = false;
  final _formkey = GlobalKey<
      FormState>(); // this is to write enter e_mail when user press buttown with enter e_mail
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose              // dispose function is used for when screen will change it will release e_mail and password from memory

    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Center(
              child: Text(
            ' Log In',
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            hintText: 'e-mail',
                            helperText: 'enter e-mail e.g mehar@gmail.com',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                            labelText: 'E-mail'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter e-mail';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: passwordcontroller,
                        obscureText: true, // for password hide
                        decoration: InputDecoration(
                            hintText: 'password',
                            helperText: 'enter your passowrd',
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(),
                            labelText: 'Password'),

                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password')),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RoundButton(
                          title: 'Log In',
                          ontap: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                showspinner = true;
                              });
                              try {
                                final User =
                                    await _auth.signInWithEmailAndPassword(
                                        email: emailcontroller.text.toString(),
                                        password:
                                            passwordcontroller.text.toString());
                                if (User != null) {
                                  Utils.flushBarErrorMessage(
                                      ' Login Successfully', context);
                                  setState(() {
                                    showspinner = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                }
                              } catch (e) {
                                print(e.toString());
                                Utils.flushBarErrorMessage(
                                    e.toString(), context);
                                setState(() {
                                  showspinner = false;
                                });
                              }
                            }
                          })
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
