import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/domain_layer/db_repository.dart';
import 'package:ride_with_me/pages/google_sign_in_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/controllers/new_ride_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'data_layer/apis/firestore_rides_api.dart';
import 'data_layer/apis/firestore_users_api.dart';
import 'data_layer/apis/users_api.dart';
import 'domain_layer/rides_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final DbRepository dbRepository = DbRepository(ridesApi: FirestoreRidesApi(), usersApi: FirestoreUsersApi());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RideFilterController()),
        ChangeNotifierProvider(create: (context) => NewRideController(ridesRepository: dbRepository.ridesRepository)),
        ChangeNotifierProvider.value(value: dbRepository),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Ride With Me",
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColorDark: Color(0xFF152F29),
          unselectedWidgetColor: Color(0x5B000000),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          textTheme: GoogleFonts.comfortaaTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        // switch directly to MainPage() is user is signed in?
        // home: FirebaseAuth.instance.currentUser == null ? InitialPage() :
        // ChangeNotifierProvider(create: (_) => UserStateController(user: FirebaseAuth.instance.currentUser), child: MainPage()),
        // home: GoogleSignInPage(),
        home: GoogleSignInPage()

      ),
    );
  }
}
