import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_with_me/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/button.dart';
import '../utils/text_field.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 60, 8, 8),
          child: InputField(placeholder: "Username", isPassword: false),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: InputField(placeholder: "Password", isPassword: true),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SubmitButton(
              value: "LOG IN",
              callback: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (_) => false,
                );
              }),
        ),
        SubmitButton(
            value: 'Use Google sign-in',
            callback: () async {
              // TODO: should provide userCredential to MainPage (as a part of state / using provider) ?
              // TODO: there has to be a better way to distinguish between web and native
              final bool isWeb = kIsWeb;
              // final platform = DefaultTargetPlatform.platform;
              // final platform = defaultTargetPlatform;
              final userCredential = isWeb ? await signInWithGoogleWeb() : await signInWithGoogleNative();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MainPage())
              );
            })
      ],
    );

    // TODO we'll need this button type, remove it from here then
    // floatingActionButton: FloatingActionButton(
    //   onPressed: ,
    //   tooltip: 'Increment',
    //   child: const Icon(Icons.add),
    // ), // This trailing comma makes auto-formatting nicer for build methods.
  }

  Future<UserCredential> signInWithGoogleNative() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

}
