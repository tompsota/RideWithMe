import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/button.dart';
import '../utils/text_field.dart';
import 'main_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  // TODO: add controllers for input fields so that we can use that info in signUp

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 60, 8, 8),
          child: InputField(placeholder: "Email", isPassword: false),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: InputField(placeholder: "Username", isPassword: false),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: InputField(placeholder: "Password", isPassword: true),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SubmitButton(
              value: "SIGN UP",
              callback: () async {
                final userCredential = await signUp();
                if (userCredential == null) {
                  // TODO: show user Toast with message 'sign-up failed' ?

                } else {
                  // user gets signed in, could
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainPage())
                  );
                }
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("By signing up, you agree to Ride With Me’s Terms of Service and Privacy Policy."),
        )
      ],
    );
  }

  // TODO: return string with error message instead of null if fail? (and null if didn't fail)
  // TODO: do we even need to return UserCredential? we can get user from FirebaseAuth.currentUser
  //       and we probably don't need other UserCredential attributes
  Future<UserCredential?> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "barry.allen@example.com",
        password: "SuperSecretPassword!"
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
