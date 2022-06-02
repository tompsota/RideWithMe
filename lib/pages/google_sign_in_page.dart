import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/components/ride_with_me_title.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/domain_layer/repositories/db_repository.dart';
import 'package:ride_with_me/utils/timed_alert_dialog.dart';
import 'main_page.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RideWithMeTitle(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/google_logo.png"),
                          height: 35.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onPressed: () async {

                    final userCredential = kIsWeb ? await _signInWithGoogleWeb() : await _signInWithGoogleNative();

                    if (userCredential.user == null) {
                      showTimedAlertDialogError(context, title: 'Sign-in failed', content: 'Need to sign in before you can continue!');
                      return;
                    }

                    final usersRepository = Provider.of<DbRepository>(context, listen: false).usersRepository;
                    final user = await usersRepository.ensureUserExists();

                    if (user == null) {
                      showTimedAlertDialogError(context, content: 'Something went wrong! Please try again...');
                      return;
                    }

                    Provider.of<UserStateController>(context, listen: false).user = user;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage(),
                      ),
                          (_) => false,
                    );
                  }),
            ),
            SizedBox(height:100),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> _signInWithGoogleNative() async {
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

  Future<UserCredential> _signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }
}
