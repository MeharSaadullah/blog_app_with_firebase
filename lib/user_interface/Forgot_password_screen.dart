import 'package:blog_app_with_firebase/Utils/utils.dart';
import 'package:blog_app_with_firebase/components/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Forgot Password Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailcontroller,
                decoration: InputDecoration(helperText: 'Enter e_mail'),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RoundButton(
                title: 'Send E-mail',
                ontap: () {
                  auth
                      .sendPasswordResetEmail(
                          email: emailcontroller.text.toString())
                      .then((value) => Utils.flushBarErrorMessage(
                          'We have sent you a e_mail to recover your password, Kindly check your email',
                          context))
                      .catchError((error) {
                    // Handle the error using the provided 'error' parameter

                    Utils.flushBarErrorMessage(error.toString(), context);
                    // setState(() {
                    //   loading = false;
                    // });
                  });
                })
          ],
        ),
      ),
    );
  }
}
