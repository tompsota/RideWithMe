import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';

import '../utils/button.dart';
import '../utils/db/ride.dart';
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
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Ride",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 56),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "With",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 56),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 80.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Me",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 56),
                  ),
                ),
              ),
            ),
            Spacer(),
            // ColorFiltered(
            //   colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.colorBurn),
            //   child: Image(image: NetworkImage('https://www.q36-5.com/wp-content/uploads/Header-desktop-RNH.jpg'),),
            // ),
            //https://www.q36-5.com/wp-content/uploads/Header-desktop-RNH.jpg

            // Image.asset("assets/foejuANBeiCtYkT6PaXW9F-768-80.jpg"),
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
                    // TODO: should provide userCredential to MainPage (as a part of state / using provider) ?
                    // TODO: there has to be a better way to distinguish between web and native
                    const bool isWeb = kIsWeb;
                    // final platform = DefaultTargetPlatform.platform;
                    // final platform = defaultTargetPlatform;

                    // TODO: uncomment after testing
                    final userCredential = isWeb ? await signInWithGoogleWeb() : await signInWithGoogleNative();

                    // // we can't create the controller inside ChangeNotifierProvider.create callback
                    // TODO: could first check, if there exists a document in 'users' collection with id = authUser.email
                    //   - if not, user has to input his first/last name etc., otherwise can just feed it into UserStateController

                    // TODO: add 'ensureCreated' that returns UserModel (creates new document if there is not a document with authUser.email)

                    
                    // final rides = await getAllRides();
                    final ridesFilterController = RideFilterController();
                    await ridesFilterController.refreshRides();
                    // ridesFilterController.filteredRides = rides;
                    // ridesFilterController.visibleRides = rides;

                    final userStateController = await UserStateController.create();
                    
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          // builder: (context) => ChangeNotifierProvider.value(value: userStateController, child: const MainPage())),
                          builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(value: userStateController),
                                ChangeNotifierProvider.value(value: ridesFilterController)
                              ],
                              child: const MainPage())),
                      (_) => false,
                    );

                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const MainPage()),
                    //       (_) => false,
                    // );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
              child: SubmitButton(
                  value: "use password instead",
                  callback: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (_) => false,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
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
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }
}
